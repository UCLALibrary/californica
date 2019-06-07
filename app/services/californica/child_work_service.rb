# frozen_string_literal: true
module Californica
  class ChildWorkService
    def child_works(member_ids_ssim:)
      return [] if member_ids_ssim.nil?
      member_ids_ssim.select do |id|
        solr_doc = SolrDocument.find(id)
        solr_doc[:has_model_ssim] == ['Work'] ||
          solr_doc[:has_model_ssim] == ['ChildWork']
      end
    end
  end
end
