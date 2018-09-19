# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaImporter do
  subject(:importer) { described_class.new(file) }
  let(:file)       { File.open(csv_path) }
  let(:csv_path)   { 'spec/fixtures/example.csv' }

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
      pending
      importer.import
      expect(File.readlines(importer.ingest_log_filename).each(&:chomp!).last).to match(/Imported 1 record(s)/)
    end
  end
end
