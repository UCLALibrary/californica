# frozen_string_literal: true

# Note:  This re-indexing tasks uses solr queries to
# determine which records to re-index.  That means
# that you can only use it to re-index solr records
# that already exist.  So, for example, it can't be
# used to repopulate the solr records after a clean.
desc 'Re-index solr records for californica works & collections'
task :reindex, [:arg1] => :environment do |_t, args|
  cutoff_timestamp = args[:arg1] || Time.zone.now.to_s
  if Time.zone.parse(cutoff_timestamp)
    ReindexEverythingFromSolrJob.perform_later cutoff_datetime: cutoff_timestamp
  else
    raise ArgumentError, "Time.zone.parse() can't parse '#{cutoff_timestamp}'."
  end
end
