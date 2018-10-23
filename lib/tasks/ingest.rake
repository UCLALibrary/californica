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
      CalifornicaImporter.new(csv_file).import
    end

    # This task is best run in production like this:
    # cd /opt/californica/current
    # RAILS_ENV=production nohup bundle exec rake californica:ingest:reingest &
    # Note that this is a very long running task and if you do not run it
    # with nohup or a similar strategy it might fail when your ssh connection ends.
    desc 'Reingest LADNN'
    task reingest: [:environment] do
      Rake::Task["californica:ingest:clean"].invoke
      Rake::Task["californica:ingest:ingest_ladnn"].invoke
    end

    desc 'Ingest sample data'
    task sample: [:environment] do
      require 'active_fedora/cleaner'
      # Re-try the cleanout process a few times in case it times out
      with_retries(max_tries: 10, base_sleep_seconds: 1, max_sleep_seconds: 10) do
        ActiveFedora::Cleaner.clean!
      end

      Hyrax::PermissionTemplate.destroy_all

      Rake::Task["hyrax:default_admin_set:create"].invoke
      Rake::Task["hyrax:default_collection_types:create"].invoke
      Rake::Task["hyrax:workflow:load"].invoke
      csv_file = Rails.root.join('spec', 'fixtures', 'ladnn-sample.csv')
      puts "------"
      puts "Benchmark for ingest of 25 sample records (elapsed real time is last):"
      puts Benchmark.measure { CalifornicaImporter.new(csv_file).import }
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
      with_retries(max_tries: 10, base_sleep_seconds: 1, max_sleep_seconds: 5) do
        response = remove_tombstone
        raise "tombstone not deleted" unless response.code == "404"
      end

      Hyrax::PermissionTemplate.destroy_all
    end

    desc "Ingest all LADNN objects"
    task ingest_ladnn: :environment do
      Rake::Task["hyrax:default_admin_set:create"].invoke
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
