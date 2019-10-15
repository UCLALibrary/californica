# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @row_id = row_id
    @row = CsvRow.find(@row_id)
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

  private

    def add_finalization_tasks(record)
      case record.mapper.object_type
      when 'Collection'
        enqueue_reindex_job(record.ark, 'Collection')
      when 'Work', 'Manuscript'
        enqueue_manifest_job(record.ark, 'Work')
        enqueue_reindex_job(record.ark, 'Work')
      when 'ChildWork', 'Page'
        enqueue_manifest_job(record.ark, 'ChildWork')
        enqueue_reindex_job(record.ark, 'Work')
      else
        raise ArgumentError, "Unknown Object Type #{row['Object Type']}"
      end
    end

    def enqueue_reindex_job(item_ark, object_type)
      import_task = CsvImportTask.create(csv_import: @csv_import,
                                         job_status: 'enqueued',
                                         job_type: 'ReindexItemJob',
                                         item_ark: item_ark,
                                         object_type: object_type)
      ReindexItemJob.perform_later(item_ark, csv_import_task_id: import_task.id)
    end

    def enqueue_manifest_job(item_ark, object_type)
      import_task = CsvImportTask.create(csv_import: @csv_import,
                                         job_status: 'enqueued',
                                         job_type: 'CreateManifestJob',
                                         item_ark: item_ark,
                                         object_type: object_type)
      CreateManifestJob.perform_later(item_ark, csv_import_task_id: import_task.id)
    end
end
