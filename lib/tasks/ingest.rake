# frozen_string_literal: true
CSV_FILE = '/opt/data/sample_data_set_la_daily_news/dlcs-ladnn-2018-09-06.csv'

namespace :californica do
  namespace :ingest do
    desc 'Ingest an item from MODS XML'
    task :mods, [:filename] => [:environment] do |_task, args|
      parser = ModsXmlParser.for(file: File.open(args[:filename]))

      Darlingtonia::Importer.new(parser: parser).import if parser.validate
    end

    desc 'Ingest an item from CSV'
    task :csv, [:filename] => [:environment] do |_task, args|
      parser = CalifornicaCsvParser.for(file: File.open(args[:filename]))

      Darlingtonia::Importer.new(parser: parser).import if parser.validate
    end

    desc "Reindex #{CSV_FILE}"
    task :reindex do
      if File.exist?(CSV_FILE)
        require 'active_fedora/cleaner'
        ActiveFedora::Cleaner.clean!
        parser = CalifornicaCsvParser.for(file: File.open(CSV_FILE))
        Darlingtonia::Importer.new(parser: parser).import if parser.validate
      else
        puts "Cannot find expected input file #{CSV_FILE}"
      end
    end
  end
end
