# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaImporter do
  subject(:importer) { described_class.new(file) }
  let(:file)       { File.open(csv_path) }
  let(:csv_path)   { 'spec/fixtures/example.csv' }

  # Cleanup log files after each test run
  after do
    File.delete(importer.ingest_log_filename) if File.exist? importer.ingest_log_filename
    File.delete(importer.error_log_filename) if File.exist? importer.error_log_filename
  end

  describe 'CSV import' do
    it 'imports records' do
      expect { importer.import }.to change { Work.count }.by 1
    end

    it "has an ingest log" do
      expect(importer.ingest_log).to be_kind_of(Logger)
    end

    it "has an error log" do
      expect(importer.error_log).to be_kind_of(Logger)
    end

    it "records the time it took to ingest" do
      importer.import
      expect(File.readlines(importer.ingest_log_filename).each(&:chomp!).last).to match(/Elapsed time/)
    end

    it "records the number of records ingested" do
      importer.import
      expect(File.readlines(importer.ingest_log_filename).each(&:chomp!).to_a[7]).to match(/Actually processed 1 records/)
    end
  end
end
