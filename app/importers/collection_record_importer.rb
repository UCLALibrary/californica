# frozen_string_literal: true

class CollectionRecordImporter < Darlingtonia::HyraxRecordImporter
  include CommonRecordImporter

  def import_type
    ::Collection
  end

  def create_for(record:)
    info_stream << "event: collection_import_started, batch_id: #{batch_id}, record_title: #{record.respond_to?(:title) ? record.title : record}"

    collection = Collection.find_or_create_by_ark(record.ark)
    collection.attributes = attributes_for(record: record)

    if collection.save
      info_stream << "event: collection_created, batch_id: #{batch_id}, record_id: #{collection.id}, record_title: #{collection.title}"
      @success_count += 1
    else
      collection.errors.each do |attr, msg|
        error_stream << "event: validation_failed, batch_id: #{batch_id}, attribute: #{attr.capitalize}, message: #{msg}, record_title: #{collection.title.first}"
      end
      @failure_count += 1
    end
  end

  def update_for(existing_record:, update_record:)
    info_stream << "event: collection_update_started, batch_id: #{batch_id}, #{deduplication_field}: #{update_record.respond_to?(deduplication_field) ? update_record.send(deduplication_field) : update_record}"

    collection = existing_record
    collection.attributes = attributes_for(record: update_record)

    if collection.save
      info_stream << "event: collection_updated, batch_id: #{batch_id}, record_id: #{collection.id}, #{deduplication_field}: #{collection.respond_to?(deduplication_field) ? collection.send(deduplication_field) : collection}"
      @success_count += 1
    else
      collection.errors.each do |attr, msg|
        error_stream << "event: validation_failed, batch_id: #{batch_id}, attribute: #{attr.capitalize}, message: #{msg}, record_title: #{collection.title.first}"
      end
      @failure_count += 1
    end
  end

  private

    # The Collection model has slightly different
    # attributes than the Work model does.
    def attributes_for(record:)
      record.attributes.except(:remote_files, :member_of_collections_attributes)
    end
end
