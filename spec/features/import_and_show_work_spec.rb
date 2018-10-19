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
    it "displays expected fields on show work page" do
      importer.import
      work = Work.last
      visit("/concern/works/#{work.id}")
      expect(page).to have_content "Communion at Plaza Church, Los Angeles, 1942-1952" # title
      expect(page).to have_content "13030/hb338nb26f" # identifier
      expect(page).to have_content "Guadalupe, Our Lady of" # subject
      expect(page).to have_content "Churches--California--Los Angeles" # subject
      expect(page).to have_content "Historic buildings--California--Los Angeles" # $subject: $z has been replaced with --
      expect(page).to have_content "still image" # resource_type
      expect(page).to have_content "copyrighted" # rights_statement
      expect(page).to have_content "news photographs" # genre
      expect(page).to have_content "Plaza Church (Los Angeles, Calif.)" # named_subject
      expect(page).to have_content "University of California, Los Angeles. Library. Department of Special Collections" # repository
      expect(page).to have_content "Los Angeles Daily News" # publisher
      expect(page).to have_content "US" # rights_country
      expect(page).to have_content "UCLA Charles E. Young Research Library Department of Special Collections, A1713 Young Research Library, Box 951575, Los Angeles, CA 90095-1575. E-mail: spec-coll@library.ucla.edu. Phone: (310)825-4988" # rights_holder
      expect(page).to have_content "1942/1952" # normalized_date
      expect(page).to have_content "uclamss_1387_b112_40911-1" # local_identifier
      expect(page).to have_content "[between 1942-1947]" # date_created
      expect(page).to have_content "1 photograph" # extent
      expect(page).to have_content "Fake Medium" # medium
      expect(page).to have_content "200x200" # dimensions
      expect(page).to have_content "Fake Funding Note" # funding_note
      expect(page).to have_content "Fake Caption" # caption
      expect(page).to have_content "No linguistic content" # language
      expect(page).to have_content "34.05707, -118.239577" # geographic_coordinates, a.k.a. latitude and longitude
    end
    it "displays expected fields on search results page" do
      importer.import
      work = Work.last
      visit("catalog?search_field=all_fields&q=")
      expect(page).to have_content work.title.first
      expect(page).to have_content work.description.first
      expect(page).to have_content work.normalized_date.first
      expect(page).to have_content work.resource_type.first
    end
  end
end
