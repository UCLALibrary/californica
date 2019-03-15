# frozen_string_literal: true

module IndexesArk
  def index_ark_fields(solr_doc)
    solr_doc['identifier_ssim'] = object.identifier
    solr_doc['ark_ssi'] = ark
  end

  def ark
    return if object.identifier.blank?
    if object.identifier.first.start_with?('ark:/')
      object.identifier.first
    else
      "ark:/" + object.identifier.first
    end
  end
end
