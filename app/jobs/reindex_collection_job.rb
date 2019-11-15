# frozen_string_literal: true

class ReindexCollectionJob < ApplicationJob
  queue_as :default

  def perform(csv_collection_reindex_id)
    @start_time = Time.zone.now
    @collection_reindex = CsvCollectionReindex.find(csv_collection_reindex_id)

    begin
      log_start

      @collection = Collection.find_by_ark(@collection_reindex.ark)
      @collection.recalculate_size = true
      @collection.save

      log_end
    rescue => e
      log_error(e)
    end
  end

  private

    def log_start
      @collection_reindex.status = 'in progress'
      @collection_reindex.start_time = @start_time
      @collection_reindex.save
    end

    def log_end
      @collection_reindex.status = 'complete'
      end_time = Time.zone.now
      @collection_reindex.end_time = end_time
      @collection_reindex.elapsed_time = end_time - @start_time
      @collection_reindex.save
    end

    def log_error(e)
      @collection_reindex.status = 'error'
      @collection_reindex.error_messages << e
      @collection_reindex.save
    end
end
