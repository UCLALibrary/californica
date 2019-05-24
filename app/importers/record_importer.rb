# frozen_string_literal: true

# This is a wrapper class to choose the right type of
# record importer.
class RecordImporter < Darlingtonia::HyraxRecordImporter
  attr_reader :actor_record_importer
  attr_reader :collection_record_importer


  def initialize(error_stream:, info_stream:, attributes: {})
    @actor_record_importer = ::ActorRecordImporter.new(error_stream: error_stream, info_stream: info_stream, attributes: attributes)
    @collection_record_importer = ::CollectionRecordImporter.new(error_stream: error_stream, info_stream: info_stream, attributes: attributes)

    super(error_stream: error_stream, info_stream: info_stream, attributes: attributes)
  end

  def import(record:)
   csv_row = CsvRow.create(metadata: record.mapper.metadata.to_json,
      row_number: record.mapper.row_number)
  CsvRowImportJob.perform_later(row_id: csv_row.id )
  end

  def success_count
    actor_record_importer.success_count + collection_record_importer.success_count
  end

  def failure_count
    actor_record_importer.failure_count + collection_record_importer.failure_count
  end
end
