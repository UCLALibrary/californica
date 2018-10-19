# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Import and Display a Work', :clean, js: false do
  subject(:importer) { CalifornicaImporter.new(file) }
  let(:file)       { File.open(csv_file) }
  let(:csv_file)   { File.join(fixture_path, 'coordinates_example.csv') }

  # Cleanup log files after each test run
  after do
    File.delete(importer.ingest_log_filename) if File.exist? importer.ingest_log_filename
    File.delete(importer.error_log_filename) if File.exist? importer.error_log_filename
    File.delete(ENV['MISSING_FILE_LOG']) if File.exist?(ENV['MISSING_FILE_LOG'])
  end

  context "after import" do
    it "displays expected fields" do
      importer.import
      work = Work.last
      visit("/concern/works/#{work.id}")
      expect(page).to have_content work.title.first
      expect(page).to have_content work.subject.first
      expect(page).to have_content work.to_solr["geographic_coordinates_ssim"]
    end
  end
end
