# frozen_string_literal: true

class CollectionRecordImporter < Darlingtonia::HyraxRecordImporter
  include CommonRecordImporter

  def import_type
    ::Collection
  end

  def create_for(record:)
    info_stream << "event: collection_import_started, batch_id: #{batch_id}, record_title: #{record.respond_to?(:title) ? record.title : record}\n"
    begin
      retries ||= 0
      collection = Collection.find_or_create_by_ark(record.ark)
    rescue Ldp::Gone
      ts_uri = "#{ActiveFedora::Base.id_to_uri(Californica::IdGenerator.id_from_ark(record.ark))}/fcr:tombstone"
      ActiveFedora.fedora.connection.delete(ts_uri)
      retry if (retries += 1) < 3
    end
    collection.attributes = attributes_for(record: record)
    collection.recalculate_size = false
    if collection.save(update_index: false)
      info_stream << "event: collection_created, batch_id: #{batch_id}, record_id: #{collection.id}, record_title: #{collection.title}\n"
      @success_count += 1
    else
      collection.errors.each do |attr, msg|
        error_stream << "event: validation_failed, batch_id: #{batch_id}, attribute: #{attr.capitalize}, message: #{msg}, record_title: #{collection.title.first}\n"
      end
      @failure_count += 1
    end
  end

  def update_for(existing_record:, update_record:)
    info_stream << "event: collection_update_started, batch_id: #{batch_id}, ark: #{update_record.ark}\n"
    collection = existing_record
    collection.attributes = attributes_for(record: update_record)
    collection.recalculate_size = false
    if collection.save
      info_stream << "event: collection_updated, batch_id: #{batch_id}, record_id: #{collection.id}, ark: #{collection.ark}\n"
      @success_count += 1
    else
      collection.errors.each do |attr, msg|
        error_stream << "event: validation_failed, batch_id: #{batch_id}, attribute: #{attr.capitalize}, message: #{msg}, record_title: #{collection.title.first}\n"
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
