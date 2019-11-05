# frozen_string_literal: true

class CreateManifestJob < ApplicationJob
  queue_as :default

  def perform(work_ark, csv_import_task_id: nil)
    log_start(csv_import_task_id)

    work = Work.find_by_ark(work_ark) || ChildWork.find_by_ark(work_ark)
    raise(ArgumentError, "No such Work or ChildWork: #{work_ark}.") unless work

    Californica::ManifestBuilderService.new(curation_concern: work).persist

    log_end(csv_import_task_id)
  end

  def deduplication_key
    "CreateManifestJob-#{arguments[0]}"
  end

  private

    def log_start(csv_import_task_id)
      return unless csv_import_task_id
      @create_manifest_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task = CsvImportTask.find(csv_import_task_id)
      csv_import_task.job_status = 'In Progress'
      begin
        csv_import_task.times_started += 1
      rescue NoMethodError
        csv_import_task = 0
      end
      csv_import_task.start_timestamp = @create_manifest_start_time
      csv_import_task.save
    end

    def log_end(csv_import_task_id)
      return unless csv_import_task_id
      csv_import_task = CsvImportTask.find(csv_import_task_id)
      @create_manifest_end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.end_timestamp = @create_manifest_end_time
      csv_import_task.job_duration = @create_manifest_end_time - @create_manifest_start_time
      csv_import_task.job_status = 'Complete'
      csv_import_task.save
    end
end
