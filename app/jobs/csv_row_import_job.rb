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
    @row.update(status: 'preparing')

    @metadata = JSON.parse(@row.metadata)
    @metadata = @metadata.merge(row_id: @row_id)
    @csv_import = CsvImport.find(@row.csv_import_id)
    import_file_path = @csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: @metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    if Flipflop.child_works?
      case record.mapper.object_type
      when 'ChildWork', 'Page'
        selected_importer = actor_record_importer
        new_status = 'complete'
      when 'Work', 'Manuscript'
        selected_importer = actor_record_importer
        new_status = 'pending finalization'
      when 'Collection'
        selected_importer = collection_record_importer
        new_status = 'pending finalization'
      else
        selected_importer = nil
        new_status = 'not imported'
      end
    else
      case record.mapper.object_type
      when 'Work', 'Manuscript'
        @row.update(status: 'deleting child works')
        Californica::Deleter.new(id: Californica::IdGenerator.id_from_ark(record.mapper.ark)).delete_with_children(of_type: ChildWork)
        @row.update(status: 'in progress')
        selected_importer = actor_record_importer
        new_status = 'complete'
      when 'Collection'
        selected_importer = collection_record_importer
        new_status = 'pending finalization'
      else
        selected_importer = nil
        new_status = 'not imported'
      end
    end

    @row.update(status: 'in progress')
    selected_importer&.import(record: record)

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @row.update(status: new_status,
                ingest_record_end_time: Time.current,
                ingest_duration: end_time - start_time,
                job_ids_completed: @row.job_ids_completed << job_id)
  rescue => e
    Rollbar.error(e, csv_import_id: @row.csv_import_id, row_id: @row_id, ark: record.mapper.ark)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @row.update(status: 'error',
                ingest_record_end_time: Time.current,
                ingest_duration: end_time - start_time,
                job_ids_errored: @row.job_ids_completed << job_id,
                error_messages: @row.error_messages << "#{e.class}: #{e.message}")
  end

  def collection_record_importer
    ::CollectionRecordImporter.new(attributes: @metadata)
  end

  def actor_record_importer
    ::ActorRecordImporter.new(attributes: @metadata)
  end
end
