# frozen_string_literal: true

# Note:  This re-indexing tasks uses solr queries to
# determine which records to re-index.  That means
# that you can only use it to re-index solr records
# that already exist.  So, for example, it can't be
# used to repopulate the solr records after a clean.
desc 'Re-index solr records for californica works & collections'
task reindex: :environment do
  ReindexEverythingFromSolrJob.perform_later
end
