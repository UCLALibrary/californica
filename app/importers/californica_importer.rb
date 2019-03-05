# frozen_string_literal: true

# Import CSV files according to UCLA ingest rules
class CalifornicaImporter
  DEDUPLICATION_FIELD = 'identifier'
  COLLECTION_ID = ENV['COLLECTION_ID']

  attr_reader :error_log, :ingest_log, :collection_id, :depositor_id

  def initialize(csv_file, collection_id: nil, depositor_id: nil)
    @csv_file = csv_file
    @collection_id = collection_id || COLLECTION_ID
    @depositor_id = depositor_id
    raise "Cannot find expected input file #{csv_file}" unless File.exist?(csv_file)
    setup_logging
  end

  def import
    raise "Cannot find expected input file #{@csv_file}" unless File.exist?(@csv_file)

    attrs = {
      collection_id: @collection_id,
      depositor_id: @depositor_id,
      deduplication_field: DEDUPLICATION_FIELD
    }

    record_importer = ActorRecordImporter.new(error_stream: @error_stream, info_stream: @info_stream, attributes: attrs)
    Darlingtonia::Importer.new(parser: parser, record_importer: record_importer, info_stream: @info_stream, error_stream: @error_stream).import if parser.validate
  end

  def parser
    @parser ||=
      CalifornicaCsvParser.new(file:         File.open(@csv_file),
                               error_stream: @error_stream,
                               info_stream:  @info_stream)
  end

  def timestamp
    @timestamp ||= Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')
  end

  def ingest_log_filename
    @ingest_log_filename ||= ENV['INGEST_LOG'] || Rails.root.join('log', "ingest_#{timestamp}.log").to_s
  end

  def error_log_filename
    @error_log_filename ||= ENV['ERROR_LOG'] || Rails.root.join('log', "errors_#{timestamp}.log").to_s
  end

  def setup_logging
    @ingest_log   = Logger.new(ingest_log_filename)
    @error_log    = Logger.new(error_log_filename)
    @info_stream  = CalifornicaLogStream.new(logger: @ingest_log, severity: Logger::INFO)
    @error_stream = CalifornicaLogStream.new(logger: @error_log,  severity: Logger::ERROR)
  end
end
