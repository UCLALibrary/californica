# frozen_string_literal: true

class CreateManifestJob < ApplicationJob
  queue_as :default

  def perform(item_ark, csv_import_id: nil)
    @item_ark = item_ark
    @csv_import_id = csv_import_id
    log_start

    work = Work.find_by_ark(item_ark) || ChildWork.find_by_ark(item_ark)
    raise(ArgumentError, "No such Work or ChildWork: #{item_ark}.") unless work

    Californica::ManifestBuilderService.new(curation_concern: work).persist

    log_end
  end

  def deduplication_key
    "CreateManifestJob-#{arguments[0]}"
  end

  private

    def csv_import_task
      @csv_import_task ||= CsvImportTask.find_or_create_by(csv_import: @csv_import,
                                                           job_type: 'CreateManifestJob',
                                                           item_ark: @item_ark)
    end

    def log_start
      @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.job_status = 'In Progress'
      begin
        csv_import_task.times_started += 1
      rescue NoMethodError
        csv_import_task.times_started = 1
      end
      csv_import_task.start_timestamp = @start_time
      csv_import_task.save
    end

    def log_end
      @end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.end_timestamp = @end_time
      csv_import_task.job_duration = @end_time - @start_time
      csv_import_task.job_status = 'Complete'
      csv_import_task.save
    end
end
