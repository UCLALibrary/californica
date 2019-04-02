# frozen_string_literal: true

# Common code that is needed by both ActorRecordImporter and CollectionRecordImporter.

module CommonRecordImporter
  # @param record [ImportRecord]
  # @return [ActiveFedora::Base]
  # Search for any existing records that match on the deduplication_field.
  # Note that we need to override this from darlingtonia so we can query for the ark,
  # which is managed just differently enough that using it as a de-duplication field won't
  # work in the standard darlingtonia way.
  def find_existing_record(record)
    return unless deduplication_field
    return unless record.respond_to?(deduplication_field)
    return if record.mapper.send(deduplication_field).nil?
    return if record.mapper.send(deduplication_field).empty?
    existing_records = import_type.where(ark_ssi: record.mapper.send(deduplication_field).to_s)
    raise "More than one record matches deduplication_field #{deduplication_field} with value #{record.mapper.send(deduplication_field)}" if existing_records.count > 1
    existing_records&.first
  end
end
