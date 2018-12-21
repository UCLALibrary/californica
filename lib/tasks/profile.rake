# frozen_string_literal: true
namespace :californica do
  namespace :ingest do
    desc 'Profile the import of one record'
    task profile: [:environment] do
      require 'profile'
      ENV['IMPORT_FILE_PATH'] = '/opt/data/connell/image/'
      csv_file = Rails.root.join('spec', 'fixtures', 'one_line_sample.csv')
      CalifornicaImporter.new(csv_file).import
    end

    desc 'Benchmark the import of one record'
    task benchmark: [:environment] do
      ENV['IMPORT_FILE_PATH'] = '/opt/data/connell/image/'
      csv_file = Rails.root.join('spec', 'fixtures', 'one_line_sample.csv')
      puts Benchmark.measure { CalifornicaImporter.new(csv_file).import }
    end
  end
end
