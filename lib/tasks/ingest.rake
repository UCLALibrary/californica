# frozen_string_literal: true
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
    desc "Delete all objects and reingest"
    task reingest: :environment do
      require 'active_fedora/cleaner'
      ActiveFedora::Cleaner.clean!
      Rake::Task["hyrax:default_collection_types:create"].invoke
      Rake::Task["californica:ingest:csv"].invoke(CSV_FILE)
    end
  end
end
