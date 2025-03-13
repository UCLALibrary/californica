# frozen_string_literal: true

class ReindexEverythingFromSolrJob < ApplicationJob
  # include Sidekiq::Worker
  include Sidekiq::Status::Worker

  queue_as Hyrax.config.ingest_queue_name

  def expiration
    @expiration ||= 60 * 60 * 24 * 365 # 1 year
  end

  def perform(cutoff_datetime: Time.zone.now.to_s)
    start_time = Time.zone.now.localtime
    cutoff_datetime = Time.zone.parse(cutoff_datetime)
    setup_logging(cutoff_datetime)
    @info_stream << "Re-index started at: #{start_time}, cutoff datetime: #{cutoff_datetime}"

    @n_remaining = @total_n_items = Float::INFINITY
    while @n_remaining.positive?
      total @total_n_items

      next_batch_ids(cutoff_datetime, 10).each_with_index do |id, i|
        at @total_n_items - @n_remaining + i, "#{@total_n_items - @n_remaining + i} / #{@total_n_items}"
        reindex_item(id)
      end

      if @n_remaining.zero?
        at @total_n_items
        break
      end
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
      if record.is_a? Collection
        record.recalculate_size = true
        record.save
      else
        record.member_of_collections.each { |collection| collection.recalculate_size = false }
        record.update_index
      end
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
    def next_batch_ids(cutoff_datetime, rows)
      @total_n_items = solr.select(params: { q: "ark_ssi:*", rows: 0 })['response']['numFound']

      # Running two different queries here is weird, but I couldn't get '-reindex_timestamp_dtsi:* OR reindex_timestamp_dtsi:[* TO #{cutoff_datetime.utc.iso8601}]' to work
      query_no_timestamp = { params: { q: "-reindex_timestamp_dtsi:*", fq: "ark_ssi:*", fl: "id", rows: rows } }
      results_no_timestamp = solr.select(query_no_timestamp)

      query_with_timestamp = { params: { q: "reindex_timestamp_dtsi:[* TO #{cutoff_datetime.utc.iso8601}]", fq: "ark_ssi:*", fl: "id", rows: rows } }
      results_with_timestamp = solr.select(query_with_timestamp)

      @n_remaining = results_no_timestamp['response']['numFound'] + results_with_timestamp['response']['numFound']

      if results_no_timestamp['response']['numFound'].positive?
        return results_no_timestamp['response']['docs'].flat_map(&:values)
      else
        return results_with_timestamp['response']['docs'].flat_map(&:values)
      end
    end

    def time_in_minutes(start_time, end_time)
      (end_time - start_time) / 60.0
    end
end
