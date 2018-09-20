# frozen_string_literal: true

# Import CSV files according to UCLA ingest rules
class CalifornicaImporter
  attr_reader :error_log, :ingest_log

  def initialize(csv_file)
    @csv_file = csv_file
    raise "Cannot find expected input file #{csv_file}" unless File.exist?(csv_file)
    setup_logging
  end

  def import
    start_time = Time.zone.now
    ingest_log.info "Beginning ingest process at #{start_time}"
    Darlingtonia::Importer.new(parser: parser).import if parser.validate
    end_time = Time.zone.now
    elapsed_time = end_time - start_time
    ingest_log.info "Finished ingest process at #{end_time}"
    ingest_log.info "Elapsed time: #{elapsed_time}"
  end

  def parser
    @parser ||= CalifornicaCsvParser.for(file: File.open(@csv_file))
  end

  def timestamp
    @timestamp ||= Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')
  end

  def ingest_log_filename
    @ingest_log_filename ||= ENV['INGEST_LOG'] || Rails.root.join('log', "ingest_#{timestamp}.log").to_s
  end

  def error_log_filename
    @ingest_log_filename ||= ENV['ERROR_LOG'] || Rails.root.join('log', "errors_#{timestamp}.log").to_s
  end

  def setup_logging
    @ingest_log = Logger.new(ingest_log_filename)
    @error_log = Logger.new(error_log_filename)
    Darlingtonia.config.default_info_stream = MessageStream.new(@ingest_log)
    Darlingtonia.config.default_error_stream = MessageStream.new(@error_log)
  end
end
