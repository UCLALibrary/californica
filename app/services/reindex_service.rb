# frozen_string_literal: true

class ReindexService
  attr_reader :solr

  # @param solr [String] the url for your alternate solr server
  def initialize(solr:)
    @original_solr = ActiveFedora::SolrService.instance.options[:url]
    @solr = solr
  end

  # Reindexes your repository content to the
  # alternate solr server.
  # @return [Boolean] the reindex success
  def reindex
    result = nil
    connected_to_alternate_solr do
      result = ActiveFedora::Base.reindex_everything
    end
    result
  end

  # This method does:
  #   1. Switch out the ActiveFedora::SolrService
  #      connection to the alternate solr server
  #   2. Do some work
  #   3. Restore the original connection
  def connected_to_alternate_solr
    ActiveFedora::SolrService.instance.conn = RSolr.connect url: @solr
    yield
    ActiveFedora::SolrService.instance.conn = RSolr.connect url: @original_solr
  end

  # Delete all documents in the alternate solr server
  def delete_all_docs
    connected_to_alternate_solr do
      conn = ActiveFedora::SolrService.instance.conn
      conn.delete_by_query("*:*", params: { commit: true })
    end
  end
end
