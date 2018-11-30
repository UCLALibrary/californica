# frozen_string_literal: true
# NOTE: This is a temporary fix because a creative commons license got left off
# of the californica data import and it needs to be fixed quickly, without re-ingesting
# all LADNN data. Do NOT run this task unless you are addressing that specific problem.
# -- Bess, 30 November 2018
namespace :californica do
  desc "Apply a creative commons license to all works"
  task fix_license: :environment do
    puts "Applying a creative commons 4.0 license to all works in the system"
    # By default a solr query will only return 10 results unless you pass it a number of rows to return:
    rows = ActiveFedora::Base.count

    # Get a list of IDs for only Work records:
    query = { params: { q: "has_model_ssim:Work", fl: "id", rows: rows } }
    solr = Blacklight.default_index.connection
    results = solr.select(query)

    # Get the list of IDs out of the query results:
    id_list = results['response']['docs'].flat_map(&:values)
    puts "There are #{id_list.size} objects to perform this task on."

    fixed = 0

    id_list.each do |id|
      work = Work.find(id)
      work.license = ["https://creativecommons.org/licenses/by/4.0/"]
      work.save
      fixed += 1
      puts "#{fixed} objects fixed" if (fixed % 100).zero? || fixed == id_list.size
    end
  end
end
