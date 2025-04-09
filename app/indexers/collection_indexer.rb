# frozen_string_literal: true

# Include any special UCLA Collection indexing here
class CollectionIndexer < Hyrax::CollectionWithBasicMetadataIndexer
  def generate_solr_document
    return solr_during_indexing unless object.recalculate_size
    super.tap do |solr_doc|
      solr_doc['thumbnail_url_ss'] = thumbnail_url
      solr_doc['title_alpha_numeric_ssort'] = object.title.first
      solr_doc['ursus_id_ssi'] = Californica::IdGenerator.blacklight_id_from_ark(object.ark)
      solr_doc['reindex_timestamp_dtsi'] = Time.zone.now
      solr_doc['record_origin_ssi'] = 'californica'
    end
  end

  # Return a minimal placeholder solr document during ingest
  def solr_during_indexing
    {
      "has_model_ssim" => ["Collection"],
      :id => object.id,
      "title_tesim" => [object.title.first.to_s],
      "title_sim" => [object.title.first.to_s],
      "collection_type_gid_ssim" => [object.collection_type_gid],
      "ark_ssi" => object.ark,
      "ursus_id_ssi" => Californica::IdGenerator.blacklight_id_from_ark(object.ark),
      "member_ids_ssim" => [],
      "object_ids_ssim" => [],
      "member_of_collection_ids_ssim" => [], "collection_ids_ssim" => [],
      "generic_type_sim" => ["Collection"],
      "bytes_lts" => 0,
      "visibility_ssi" => "restricted",
      "reindex_timestamp_dtsi" => Time.zone.now,
      "record_origin_ssi" => "californica"
    }
  end

  def thumbnail_url
    thumbnail = object.thumbnail_link || thumbnail_from_access_copy
    case thumbnail
    when /\.(svg)|(png)|(jpg)$/
      thumbnail
    when /\/iiif\/2\/[^\/]+$/
      "#{thumbnail}/full/!200,200/0/default.jpg"
    else
      return nil
    end
  end

  def thumbnail_from_access_copy
    iiif_resource = Californica::ManifestBuilderService.new(curation_concern: object).iiif_url

    children = Array.wrap(object.members).clone
    until iiif_resource || children.empty?
      child = children.shift
      iiif_resource = Californica::ManifestBuilderService.new(curation_concern: child).iiif_url

      grandchildren = Array.wrap(child.members).clone
      until iiif_resource || grandchildren.empty?
        grandchild = grandchildren.shift
        iiif_resource = Californica::ManifestBuilderService.new(curation_concern: grandchild).iiif_url
      end
    end

    iiif_resource
  end
end
