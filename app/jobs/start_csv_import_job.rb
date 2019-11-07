# frozen_string_literal: true

class StartCsvImportJob < ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  def perform(csv_import_id)
    @csv_import = CsvImport.find csv_import_id
    setup_logging
    @info_stream << "StartCsvImportJob ~ Starting import with batch ID: #{csv_import_id}"
    importer = CalifornicaImporter.new(@csv_import, info_stream: @info_stream, error_stream: @error_stream)
    importer.import

  rescue => e
    @error_stream << "StartCsvImportJob failed: #{e.message}\n#{e.backtrace.inspect}"
  end

  def ingest_log_filename
    Rails.root.join('log', "ingest_#{@csv_import.id}.log").to_s
  end

  def setup_logging
    @ingest_log   = Logger.new(ingest_log_filename)
    @info_stream  = CalifornicaLogStream.new(logger: @ingest_log, severity: Logger::INFO)
    @error_stream = CalifornicaLogStream.new(logger: @ingest_log, severity: Logger::ERROR)
  end
end
