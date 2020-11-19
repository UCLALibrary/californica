# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ENV["TZ"]
    ENV["TZ"] = "America/Los_Angeles"
    Time.zone = "America/Los_Angeles"

    @row_id = row_id
    @row = CsvRow.find(@row_id)
    @row.ingest_record_start_time = Time.current

    @metadata = JSON.parse(@row.metadata)

###    unless @metadata["Item ARK"] == ""
###      # build the backwards ark to query Fedora
###      fedora_ark2 = @metadata["Item ARK"]
###      fedora_ark3 = fedora_ark2.sub("ark:/", "")
###      fedora_ark4 = fedora_ark3.sub("/", "-")
###      fedora_ark5 = fedora_ark4.reverse
###      fedora_ark6a = fedora_ark5.split("-")
###      fedora_ark6 = fedora_ark6a.first
###      fedora_ark7 = fedora_ark6.scan(/\w/)
###      fedora_ark8 = ""
###      ark_cnt = 0
###      fedora_ark7.each do |ark_l|
###        fedora_ark8 += "/" if ark_cnt.modulo(2).zero?
###        fedora_ark8 += ark_l
###        ark_cnt += 1
###      end
###      fedora_ark8 += "/"
###      fedora_ark9 = fedora_ark8 + fedora_ark5
###      fedora_ark10 = fedora_ark9.sub("/zz/", "/")
###
###      # build Fedora URI and remove tombstone if present
###      url = "#{ActiveFedora.config.credentials[:url]}#{ActiveFedora.config.credentials[:base_path]}"
###      fedora_ark11 = url + fedora_ark10
###      uri = URI(fedora_ark11)
###      fedora_resp = Net::HTTP.get_response(uri)
###
###      if fedora_resp.body["ombstone"]
###        fedora_ark11 += "/fcr:tombstone"
###        uri = URI(fedora_ark11)
###        http = Net::HTTP.new(uri.host, uri.port)
###        req = Net::HTTP::Delete.new(uri.path)
###        req.basic_auth ActiveFedora.config.credentials[:user], ActiveFedora.config.credentials[:password]
###        http.request(req)
###        tombstone_msg_ary = Array.new(1, "tombstone removed")
###        @row.error_messages = tombstone_msg_ary
###      end
###    end

    @row.status = @metadata["Object Type"].include?("Page") ? 'not ingested' : 'in progress'
    @metadata = @metadata.merge(row_id: @row_id)
    @csv_import = CsvImport.find(@row.csv_import_id)
    import_file_path = @csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: @metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    selected_importer = if record.mapper.collection?
                          collection_record_importer
                        else
                          actor_record_importer
                        end

    selected_importer.import(record: record) unless @metadata["Object Type"].include?("Page")
    
    @row.status = if ['Page', 'ChildWork'].include?(record.mapper.object_type)
                    if @metadata["Object Type"].include?("Page")
                      "not ingested"
                    else
                      "complete"
                    end
                  else
                    "pending finalization"
                  end

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @row.ingest_record_end_time = Time.current

    ingest_duration = end_time - start_time
    @row.ingest_duration = ingest_duration
    @row.job_ids_completed << job_id
    @row.save
  rescue => e
    @row.status = 'error'
    @row.job_ids_errored << job_id
    @row.error_messages << e.message
    @row.save
  end

  def collection_record_importer
    ::CollectionRecordImporter.new(attributes: @metadata)
  end

  def actor_record_importer
    ::ActorRecordImporter.new(attributes: @metadata)
  end
end
