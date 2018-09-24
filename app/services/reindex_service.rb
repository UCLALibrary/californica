# frozen_string_literal: true

class ReindexService
  attr_reader :solr

  # @param solr [String] the url for your alternate solr server
  def initialize(solr:)
    @original_solr = ActiveFedora::SolrService.instance.options[:url]
    @solr = solr
  end

  # Switches out the ActiveFedora::SolrService connection to a
  # a solr server that you specify and then reindexes your
  # repository content for that server. It then restores the original
  # connection
  #
  # @return [Boolean] the reindex success
  def reindex
    ActiveFedora::SolrService.instance.conn = RSolr.connect url: @solr
    result = ActiveFedora::Base.reindex_everything
    ActiveFedora::SolrService.instance.conn = RSolr.connect url: @original_solr
    result
  end
end
