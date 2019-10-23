# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ENV["TZ"]
    ENV["TZ"] = "America/Los_Angeles"
    Time.zone = "America/Los_Angeles"

    @row_id = row_id
    @row = CsvRow.find(@row_id)
    @row.start_time = Time.current

    @row.status = 'In Progress'
    @metadata = JSON.parse(@row.metadata)
    @metadata = @metadata.merge(row_id: @row_id)
    @csv_import = CsvImport.find(@row.csv_import_id)
    import_file_path = @csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: @metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    selected_importer = if record.mapper.collection?
                          collection_record_importer
                        else
                          actor_record_importer
                        end
    selected_importer.import(record: record)
    ReindexItemJob.perform_later(record.ark, csv_import_id: @csv_import.id)
    @row.status = "complete"

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @row.end_time = Time.current

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
