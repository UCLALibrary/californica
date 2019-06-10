# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    @row_id = row_id
    @row = CsvRow.find(@row_id)
    @metadata = JSON.parse(@row.metadata)
    @metadata = @metadata.merge(row_id: @row_id)
    @csv_import = CsvImport.find(@row.csv_import_id)
    import_file_path = @csv_import.import_file_path
    record = Darlingtonia::InputRecord.from(metadata: @metadata, mapper: CalifornicaMapper.new(import_file_path: import_file_path))

    selected_importer = if record.mapper.collection?
                          collection_record_importer
                        else
                          actor_record_importer
                        end
    selected_importer.import(record: record)

    @row.status = 'complete'
    @row.save
  rescue => e
    @row.status = 'error'
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
