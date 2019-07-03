# frozen_string_literal: true

class StartCsvImportJob < ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  def perform(csv_import_id)
    csv_import = CsvImport.find csv_import_id
    log_stream = Darlingtonia.config.default_info_stream
    log_stream << "Starting import with batch ID: #{csv_import_id}"
    importer = CalifornicaImporter.new(csv_import)
    importer.import
  rescue => e
    log_stream << "CsvImportJob failed: #{e.message}"
  end
end
