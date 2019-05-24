# frozen_string_literal: true
class CsvRowImportJob < ActiveJob::Base
  def perform(row_id:)
    row = CsvRow.find(row_id)
    metadata = JSON.parse(row.metadata)
    record = Darlingtonia::InputRecord.from(metadata: metadata, mapper: CalifornicaMapper.new(import_file_path: '/opt/data' ))

    collection_record_importer = ::CollectionRecordImporter.new(attributes: metadata)

    actor_record_importer = ::ActorRecordImporter.new(attributes: metadata)
    selected_importer = if record.mapper.collection?
      collection_record_importer
    else
      actor_record_importer
    end
    selected_importer.import(record: record)

    row.status = 'complete'
    row.save
  end
end
