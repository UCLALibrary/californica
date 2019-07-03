# frozen_string_literal: true

# Import CSV files according to UCLA ingest rules
class CalifornicaImporter
  attr_reader :error_log, :ingest_log, :depositor_id, :import_file_path

  # @param [CsvImport] csv_import
  def initialize(csv_import)
    @csv_import = csv_import
    @csv_file = csv_import.manifest.to_s
    @import_file_path = csv_import.import_file_path
    @depositor_id = csv_import.user_id
    raise "Cannot find expected input file #{@csv_file}" unless File.exist?(@csv_file)
    setup_logging
  end

  def import
    raise "Cannot find expected input file #{@csv_file}" unless File.exist?(@csv_file)

    attrs = {
      depositor_id: @depositor_id,
      batch_id: @csv_import.id
    }

    record_importer = ::RecordImporter.new(error_stream: @error_stream, info_stream: @info_stream, attributes: attrs)
    raise "CSV file #{@csv_file} did not validate" unless parser.validate
    Darlingtonia::Importer.new(parser: parser, record_importer: record_importer, info_stream: @info_stream, error_stream: @error_stream).import
    parser.order_child_works
    parser.reindex_collections
  rescue => e
    @error_stream << "CsvImportJob failed: #{e.message}"
  end

  def parser
    @parser ||=
      CalifornicaCsvParser.new(file:         File.open(@csv_file),
                               import_file_path: @import_file_path,
                               error_stream: @error_stream,
                               info_stream:  @info_stream)
  end

  def timestamp
    @timestamp ||= Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')
  end

  def ingest_log_filename
    Rails.root.join('log', "ingest_#{@csv_import.id}.log").to_s
  end

  def error_log_filename
    Rails.root.join('log', "errors_#{@csv_import.id}.log").to_s
  end

  def setup_logging
    @ingest_log   = Logger.new(ingest_log_filename)
    @error_log    = Logger.new(error_log_filename)
    @info_stream  = CalifornicaLogStream.new(logger: @ingest_log, severity: Logger::INFO)
    @error_stream = CalifornicaLogStream.new(logger: @error_log,  severity: Logger::ERROR)
  end
end
