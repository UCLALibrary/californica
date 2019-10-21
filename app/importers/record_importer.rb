# frozen_string_literal: true

# This is a wrapper class to choose the right type of
# record importer.
class RecordImporter < Darlingtonia::HyraxRecordImporter
  attr_reader :actor_record_importer
  attr_reader :collection_record_importer
  attr_reader :info_stream, :error_stream
  attr_accessor :csv_table

  def initialize(error_stream:, info_stream:, attributes: {})
    @info_stream = info_stream
    @error_stream = error_stream
    @actor_record_importer = ::ActorRecordImporter.new(error_stream: @error_stream, info_stream: @info_stream, attributes: attributes)
    @collection_record_importer = ::CollectionRecordImporter.new(error_stream: @error_stream, info_stream: @info_stream, attributes: attributes)
    super(error_stream: @error_stream, info_stream: @info_stream, attributes: attributes)
  end

  def import(record:)
    csv_row = CsvRow.create(
      metadata: record.mapper.metadata.to_json,
      row_number: record.mapper.row_number,
      csv_import_id: batch_id,
      object_type: record.mapper.object_type,
      no_of_children: count_children(record),
      status: 'queued'
    )
    CsvRowImportJob.perform_later(row_id: csv_row.id)
  end

  def count_children(record)
    item_ark = record.mapper.ark.sub('ark:/', '')
    row_with_specified_ark = csv_table.find_all do |row|
      row if row.field('Parent ARK') == item_ark
    end
    row_with_specified_ark.length
  end

  def success_count
    actor_record_importer.success_count + collection_record_importer.success_count
  end

  def failure_count
    actor_record_importer.failure_count + collection_record_importer.failure_count
  end
end
