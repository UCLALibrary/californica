# frozen_string_literal: true

# Include any special UCLA Collection indexing here
class CollectionIndexer < Hyrax::CollectionWithBasicMetadataIndexer
  def generate_solr_document
    return solr_during_indexing unless object.recalculate_size
    super.tap do |solr_doc|
      solr_doc['ursus_id_ssi'] = Californica::IdGenerator.blacklight_id_from_ark(object.ark)
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
end
