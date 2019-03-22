# frozen_string_literal: true

module IndexesArk
  def index_ark_fields(solr_doc)
    solr_doc['identifier_ssim'] = object.identifier
    solr_doc['ark_ssi'] = ark
  end

  def ark
    Ark.ensure_prefix(object.identifier.first)
  end
end
