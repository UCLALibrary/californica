# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    row = CsvRow.find(row_id)
    metadata = JSON.parse(row.metadata)
    csv_import = CsvImport.find(row.csv_import_id)
    import_file_path = csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    collection_record_importer = ::CollectionRecordImporter.new(attributes: metadata)
    actor_record_importer = ::ActorRecordImporter.new(attributes: metadata)
    selected_importer = if record.mapper.collection?
                          collection_record_importer
                        else
                          actor_record_importer
                        end
    selected_importer.import(record: record)

    @row.job_ids_completed << job_id
    @row.save
  rescue => e
    @row.job_ids_errored << job_id
    @row.error_messages << e.message
    @row.save
  end

  def collection_record_importer
    ::CollectionRecordImporter.new(attributes: @metadata)
  end

  def actor_record_importer
    ::ActorRecordImporter.new(attributes: @metadata)
  end
end
