# frozen_string_literal: true

class CreateManifestJob < ApplicationJob
  queue_as :default

  def perform(work_ark, create_manifest_object_id: nil)
    @start_time = Time.zone.now
    @work_ark = work_ark
    @create_manifest_object = CsvImportCreateManifest.find(create_manifest_object_id) if create_manifest_object_id

    log_start

    work = Work.find_by_ark(work_ark) || ChildWork.find_by_ark(work_ark)
    raise(ArgumentError, "No such Work or ChildWork: #{work_ark}.") unless work

    Californica::ManifestBuilderService.new(curation_concern: work).persist

    log_end

  rescue => e
    if @create_manifest_object
      log_error(e)
    else
      raise
    end
  end

  private

    def log_start
      return unless @create_manifest_object
      @create_manifest_object.status = 'in progress'
      @create_manifest_object.start_time = @start_time
      @create_manifest_object.save
    end

    def log_end
      return unless @create_manifest_object
      @create_manifest_object.status = 'complete'
      end_time = Time.zone.now
      @create_manifest_object.end_time = end_time
      @create_manifest_object.elapsed_time = end_time - @start_time
      @create_manifest_object.save
    end

    def log_error(e)
      @create_manifest_object.status = 'error'
      @create_manifest_object.error_messages << e.to_s
      @create_manifest_object.save
    end
end
