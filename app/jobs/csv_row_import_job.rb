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

    # build the backwards ark to query Fedora
    fedoraArk2 = @metadata["Item ARK"]
    fedoraArk3 = fedoraArk2.sub("ark:/","")
    fedoraArk4 = fedoraArk3.sub("/","-")
    fedoraArk5 = fedoraArk4.reverse
    fedoraArk6a = fedoraArk5.split("-")
    fedoraArk6 = fedoraArk6a.first()
    fedoraArk7 = fedoraArk6.scan /\w/
    fedoraArk8 = ""
    arkCnt = 0
    fedoraArk7.each do |arkL|
      if arkCnt.modulo(2) == 0
        fedoraArk8 += "/"
      end
      fedoraArk8 += arkL
      arkCnt += 1
    end
    fedoraArk8 += "/"
    fedoraArk9 = fedoraArk8 + fedoraArk5
    fedoraArk10 = fedoraArk9.sub("/zz/","/")

    # build Fedora URI and remove tombstone if present
    url = "#{ActiveFedora.config.credentials[:url]}#{ActiveFedora.config.credentials[:base_path]}"
    fedoraArk11 = url + fedoraArk10
    uri = URI(fedoraArk11)
    fedoraResp = Net::HTTP.get_response(uri)

    if fedoraResp.body["ombstone"]
      fedoraArk11 = fedoraArk11 + "/fcr:tombstone"
      uri = URI(fedoraArk11)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Delete.new(uri.path)
      req.basic_auth ActiveFedora.config.credentials[:user], ActiveFedora.config.credentials[:password]
      http.request(req)
      tombstoneMsgAry = Array.new(1, "tombstone removed")
      @row.error_messages = tombstoneMsgAry
    end

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