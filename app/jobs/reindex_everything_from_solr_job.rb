# frozen_string_literal: true

class ReindexEverythingFromSolrJob < ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  def perform
    start_time = Time.zone.now.localtime
    setup_logging(start_time)
    @info_stream << "Re-index started at: #{start_time}"

    models_to_reindex = [::Collection] + Hyrax.config.curation_concerns
    models_to_reindex.each do |klass|
      rows = klass.count
      @info_stream << "Re-indexing #{rows} #{klass} records: #{Time.zone.now.localtime}"

      id_list(klass, rows).each { |id| reindex_item(id) }
    end

    end_time = Time.zone.now.localtime
    @info_stream << "Re-index finished at: #{end_time}\nRe-index took: #{time_in_minutes(start_time, end_time)&.round} minutes \n"

  rescue => e
    @error_stream << "ReindexEverythingFromSolrJob failed: #{e.message}\n#{e.backtrace.inspect}"
  end

  private

    def reindex_item(id)
      return unless ActiveFedora::Base.exists?(id)
      record = ActiveFedora::Base.find(id)
      record.update_index
    rescue => e
      @error_stream << "Failed to reindex #{id}: #{e.message}\n#{e.backtrace.inspect}"
    end

    def reindex_log_filename(start_time)
      Rails.root.join('log', "reindex_#{start_time}.log").to_s
    end

    def setup_logging(start_time)
      @reindex_log = Logger.new(reindex_log_filename(start_time))
      @info_stream  = CalifornicaLogStream.new(logger: @reindex_log, severity: Logger::INFO)
      @error_stream = CalifornicaLogStream.new(logger: @reindex_log, severity: Logger::ERROR)
    end

    def solr
      Blacklight.default_index.connection
    end

    # Get the list of IDs from the query results:
    def id_list(model, rows)
      query = { params: { q: "has_model_ssim:#{model}", fl: "id", rows: rows } }
      results = solr.select(query)
      results['response']['docs'].flat_map(&:values)
    end

    def time_in_minutes(start_time, end_time)
      (end_time - start_time) / 60.0
    end
end
