# frozen_string_literal: true

class ReindexItemJob < ApplicationJob
  queue_as :default

  def perform(item_ark, csv_import_id: nil)
    @item_ark = item_ark
    @csv_import_id = csv_import_id
    log_start

    item = Collection.find_by_ark(item_ark) || Work.find_by_ark(item_ark) || ChildWork.find_by_ark(item_ark)
    raise(ArgumentError, "No such item: #{item_ark}.") unless item

    # Apply page orderings if importing Works from a CSV
    if csv_import_id && item.is_a?(Work)
      page_orderings = PageOrder.where(parent: Ark.ensure_prefix(item_ark))
      ordered_arks = page_orderings.sort_by(&:sequence)
      item.ordered_members = ordered_arks.map { |b| ChildWork.find_by_ark(b.child) }
    end

    enable_recalculate_size(item)
    item.save

    CreateManifestJob.perform_later(item_ark, csv_import_id: @csv_import_id) unless item.is_a? Collection
    item.member_of.each do |parent|
      ReindexItemJob.perform_later(parent.ark, csv_import_id: @csv_import_id)
    end

    log_end
  end

  def deduplication_key
    "ReindexItemJob-#{arguments[0]}"
  end

  private

    def csv_import_task
      @csv_import_task ||= CsvImportTask.find_or_create_by(csv_import_id: @csv_import_id,
                                                           job_type: 'ReindexItemJob',
                                                           item_ark: @item_ark)
    end

    def log_start
      @reindex_log_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.object_type = item.class
      csv_import_task.job_status = 'In Progress'
      begin
        csv_import_task.times_started += 1
      rescue NoMethodError
        csv_import_task.times_started = 1
      end
      csv_import_task.start_timestamp = @reindex_log_start_time
      csv_import_task.save
    end

    def log_end
      @reindex_log_end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      csv_import_task.end_timestamp = @reindex_log_end_time
      csv_import_task.job_duration = @reindex_log_end_time - @reindex_log_start_time
      csv_import_task.job_status = 'Complete'
      csv_import_task.save
    end

    def enable_recalculate_size(item)
      item.recalculate_size = true
    rescue NoMethodError
      nil
    end
end
