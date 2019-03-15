# frozen_string_literal: true

class CollectionIndexer < Hyrax::CollectionWithBasicMetadataIndexer
  include IndexesArk

  def generate_solr_document
    super.tap do |solr_doc|
      index_ark_fields(solr_doc)
    end
  end
end
