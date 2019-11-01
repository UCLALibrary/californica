# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    log_start
    @metadata = JSON.parse(csv_row.metadata)
    @metadata = @metadata.merge(row_id: row_id)
    @csv_import = CsvImport.find(csv_row.csv_import_id)
    import_file_path = @csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: @metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    selected_importer = if record.mapper.collection?
                          collection_record_importer
                        else
                          actor_record_importer
                        end
    selected_importer.import(record: record)
    ReindexItemJob.perform_later(record.ark, csv_import_id: @csv_import.id)
    log_end
  rescue => e
    csv_row.status = 'error'
    csv_row.job_ids_errored << job_id
    csv_row.error_messages << e.message
    csv_row.save
  end

  def collection_record_importer
    ::CollectionRecordImporter.new(attributes: @metadata)
  end

  def actor_record_importer
    ::ActorRecordImporter.new(attributes: @metadata)
  end

  private

    def csv_import
      @csv_import ||= CsvImport.find(csv_row.csv_import_id)
    end

    def csv_row
      @csv_row ||= CsvRow.find(arguments[0][:row_id])
    end

    def log_end
      csv_row.status = "complete"
      csv_row.ingest_record_end_time = Time.current
      csv_row.ingest_duration = csv_row.ingest_record_end_time - csv_row.ingest_record_start_time
      csv_row.job_ids_completed << job_id
      csv_row.save

      Californica::CsvImportService.new(csv_import).update_status
    end

    def log_start
      @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      ENV["TZ"] = "America/Los_Angeles"
      Time.zone = "America/Los_Angeles"

      csv_row.ingest_record_start_time = Time.current
      csv_row.status = 'in progress'
      csv_row.save
    end
end
