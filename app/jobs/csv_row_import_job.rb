# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  # Represents an import job for a single row in a CSV
  #
  # @param row [CsvRow]
  # @param csv_import [CsvImport]
  def perform(row:, csv_import:)
    metadata = JSON.parse(row.metadata)
    metadata = metadata.merge(row_id: row.id)

    import_file_path = csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    selected_importer = if record.mapper.collection?
                          ::CollectionRecordImporter.new(attributes: metadata)
                        else
                          ::ActorRecordImporter.new(attributes: metadata)
                        end
    selected_importer.import(record: record)

    row.job_ids_completed << job_id
    row.save
  rescue => e
    row.job_ids_errored << job_id
    row.error_messages << e.message
    row.save
  end
end
