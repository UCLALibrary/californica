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
    selected_importer = if record.mapper.collection?
                          collection_record_importer
                        else
                          actor_record_importer
                        end
    selected_importer.import(record: record)
  end

  def success_count
    actor_record_importer.success_count + collection_record_importer.success_count
  end

  def failure_count
    actor_record_importer.failure_count + collection_record_importer.failure_count
  end
end
