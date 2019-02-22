# frozen_string_literal: true

# Note:  This re-indexing tasks uses solr queries to
# determine which records to re-index.  That means
# that you can only use it to re-index solr records
# that already exist.  So, for example, it can't be
# used to repopulate the solr records after a clean.
desc 'Re-index solr records for californica works & collections'
task reindex: :environment do
  $stdout.sync = true # Flush output immediately

  start_time = Time.zone.now.localtime
  puts "Re-index started at: #{start_time}"

  models_to_reindex = [::Collection] + Hyrax.config.curation_concerns
  models_to_reindex.each do |klass|
    rows = klass.count
    puts "Re-indexing #{rows} #{klass} records: #{Time.zone.now.localtime}"

    id_list(klass, rows).each do |id|
      next unless ActiveFedora::Base.exists?(id)
      record = ActiveFedora::Base.find(id)
      record.update_index
    end
  end

  end_time = Time.zone.now.localtime
  puts "Re-index finished at: #{end_time}"
  printf "Re-index finished in: %0.1f minutes \n", time_in_minutes(start_time, end_time)
end

def solr
  Blacklight.default_index.connection
end

# Get the list of IDs from the query results:
def id_list(model, rows)
  query = { params: { q: "has_model_ssim:#{model}", fl: "id", rows: rows } }
  results = solr.select(query)
  results['response']['docs'].flat_map(&:values)
end

def time_in_minutes(start_time, end_time)
  (end_time - start_time) / 60.0
end
