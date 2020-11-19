# frozen_string_literal: true

class CollectionRecordImporter < Darlingtonia::HyraxRecordImporter
  include CommonRecordImporter

  def import_type
    ::Collection
  end

  def create_for(record:)

    begin
    retries ||= 0

    info_stream << "event: collection_import_started, batch_id: #{batch_id}, record_title: #{record.respond_to?(:title) ? record.title : record}\n"

    collection = Collection.find_or_create_by_ark(record.ark)
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
    rescue Ldp::Gone => e

    
    fedora_ark2 = record.ark
    fedora_ark3 = fedora_ark2.sub("ark:/", "")
    fedora_ark4 = fedora_ark3.sub("/", "-")
    fedora_ark5 = fedora_ark4.reverse
    fedora_ark6a = fedora_ark5.split("-")
    fedora_ark6 = fedora_ark6a.first
    fedora_ark7 = fedora_ark6.scan(/\w/)
    fedora_ark8 = ""
    ark_cnt = 0
    fedora_ark7.each do |ark_l|
      fedora_ark8 += "/" if ark_cnt.modulo(2).zero?
      fedora_ark8 += ark_l
      ark_cnt += 1
    end
    fedora_ark8 += "/"
    fedora_ark9 = fedora_ark8 + fedora_ark5
    fedora_ark10 = fedora_ark9.sub("/zz/", "/")
    url = "#{ActiveFedora.config.credentials[:url]}#{ActiveFedora.config.credentials[:base_path]}#{fedora_ark10}/fcr:tombstone"
    ActiveFedora.fedora.connection.delete(url)
    retry if (retries += 1) < 3
    end




  end

  def update_for(existing_record:, update_record:)
    retries ||= 0
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
  rescue Ldp::BadRequest => e
    raise << "testtesttest"
    retry if (retries += 1) < 3
  end

  private

    # The Collection model has slightly different
    # attributes than the Work model does.
    def attributes_for(record:)
      record.attributes.except(:remote_files, :member_of_collections_attributes)
    end
end
