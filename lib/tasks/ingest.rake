# frozen_string_literal: true
require 'retries'

# Set this value in .env.development or .env.production, according to your
# environment
CSV_FILE = ENV['CSV_FILE']

namespace :californica do
  namespace :ingest do
    desc 'Ingest an item from CSV'
    task :csv, [:filename] => [:environment] do |_task, args|
      csv_file = args[:filename]
      if File.exist?(csv_file)
        parser = CalifornicaCsvParser.for(file: File.open(csv_file))
        Darlingtonia::Importer.new(parser: parser).import if parser.validate
      else
        puts "Cannot find expected input file #{csv_file}"
      end
    end

    # While we are in development mode, this task is scheduled to run nightly.
    # Adjust this in config/schedule.rb if necessary.
    desc "Cleanout fedora"
    task clean: :environment do
      require 'active_fedora/cleaner'
      # Re-try the cleanout process a few times in case it times out
      with_retries(max_tries: 10, base_sleep_seconds: 500, max_sleep_seconds: 1000) do
        ActiveFedora::Cleaner.clean!
      end
    end

    # While we are in development mode, this task is scheduled to run nightly.
    # Adjust this in config/schedule.rb if necessary.
    desc "Delete all objects and reingest"
    task reingest: :environment do
      Rake::Task["californica:ingest:clean"].invoke
      with_retries(max_tries: 10, base_sleep_seconds: 1, max_sleep_seconds: 5) do
        response = remove_tombstone
        raise "tombstone not deleted" unless response.code == "404"
      end

      Rake::Task["hyrax:default_collection_types:create"].invoke
      Rake::Task["californica:ingest:csv"].invoke(CSV_FILE)
    end

    def remove_tombstone
      # ActiveFedora::Cleaner sometimes leaves a tombstone resource in place at /prod
      # This prevents the content from re-ingesting. It has to be explicitly removed.
      url = "#{ActiveFedora.config.credentials[:url]}#{ActiveFedora.config.credentials[:base_path]}/fcr:tombstone"
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Delete.new(uri.path)
      req.basic_auth ActiveFedora.config.credentials[:user], ActiveFedora.config.credentials[:password]
      http.request(req)
    end
  end
end
