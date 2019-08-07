# frozen_string_literal: true

# Include any special UCLA Collection indexing here
class CollectionIndexer < Hyrax::CollectionWithBasicMetadataIndexer
  def generate_solr_document
    return solr_during_indexing unless object.recalculate_size
    super.tap do |solr_doc|
      solr_doc['ursus_id_ssi'] = Californica::IdGenerator.blacklight_id_from_ark(object.ark)
      solr_doc['thumbnail_url_ss'] = thumbnail_url
    end
  end

  # Return a minimal placeholder solr document during ingest
  def solr_during_indexing
    {
      "has_model_ssim" => ["Collection"],
      :id => object.id,
      "title_tesim" => ["Ingesting now: #{object.title.first}"],
      "title_sim" => ["Ingesting now: #{object.title.first}"],
      "collection_type_gid_ssim" => [object.collection_type_gid],
      "ark_ssi" => object.ark,
      "ursus_id_ssi" => Californica::IdGenerator.blacklight_id_from_ark(object.ark),
      "member_ids_ssim" => [],
      "object_ids_ssim" => [],
      "member_of_collection_ids_ssim" => [], "collection_ids_ssim" => [],
      "generic_type_sim" => ["Collection"],
      "bytes_lts" => 0,
      "visibility_ssi" => "restricted"
    }
  end

  def thumbnail_url
    # this record has an image path attached

    access_copy = object.access_copy
    children = Array.wrap(object.members).clone

    until access_copy || children.empty?
      child = children.shift

      if (child.respond_to? 'access_copy') && !child.access_copy.nil?
        access_copy = child.access_copy
      else
        grandchildren = Array.wrap(child.members).clone
        until access_copy || grandchildren.empty?
          grandchild = grandchildren.shift
          access_copy = grandchild.access_copy
        end
      end
    end

    return nil unless access_copy
    "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(access_copy)}/full/!200,200/0/default.jpg"
  end
end
