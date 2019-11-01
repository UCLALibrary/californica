# frozen_string_literal: true

class CreateManifestJob < ApplicationJob
  queue_as :default

  def perform(item_ark, csv_import_id: nil)
    @item_ark = item_ark
    @csv_import_id = csv_import_id
    log_start if csv_import_id

    raise(ArgumentError, "No such Work or ChildWork: #{item_ark}.") unless item

    Californica::ManifestBuilderService.new(curation_concern: item).persist

    log_end if csv_import_id
  end

  def deduplication_key
    "CreateManifestJob-#{arguments[0]}"
  end

  private

    def csv_import
      return nil unless @csv_import_id
      @csv_import ||= CsvImport.find(@csv_import_id)
    end

    def csv_import_task
      @csv_import_task ||= CsvImportTask.find_or_create_by(csv_import_id: @csv_import_id,
                                                           job_type: 'CreateManifestJob',
                                                           item_ark: @item_ark)
    end

    def item
      @item ||= (Work.find_by_ark(@item_ark) || ChildWork.find_by_ark(@item_ark))
    end

    def log_start
      @create_manifest_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.object_type = item.class
      csv_import_task.job_status = 'in progress'
      begin
        csv_import_task.times_started += 1
      rescue NoMethodError
        csv_import_task.times_started = 1
      end
      csv_import_task.start_timestamp = @create_manifest_start_time
      csv_import_task.save
    end

    def log_end
      @create_manifest_end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.end_timestamp = @create_manifest_end_time
      csv_import_task.job_duration = @create_manifest_end_time - @create_manifest_start_time
      csv_import_task.job_status = 'complete'
      csv_import_task.save

      Californica::CsvImportService.new(csv_import).update_status
    end
end
