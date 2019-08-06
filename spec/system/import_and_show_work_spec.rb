# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Import and Display a Work', :clean, type: :system, inline_jobs: true, js: true do
  subject(:importer) { CalifornicaImporter.new(csv_import, info_stream: [], error_stream: []) }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest) }
  let(:manifest) { Rack::Test::UploadedFile.new(csv_file, 'text/csv') }
  let(:csv_file)   { File.join(fixture_path, 'coordinates_example.csv') }
  let(:user)       { FactoryBot.create(:admin) }
  let(:collection) { Collection.find_or_create_by_ark('ark:/111/222') }

  context "importing the same object twice" do
    let(:first_csv_import) { FactoryBot.create(:csv_import, user: user, manifest: first_manifest) }
    let(:first_manifest) { Rack::Test::UploadedFile.new(File.join(fixture_path, 'coordinates_example.csv'), 'text/csv') }
    let(:first_importer) { CalifornicaImporter.new(first_csv_import) }

    let(:second_csv_import) { FactoryBot.create(:csv_import, user: user, manifest: second_manifest) }
    let(:second_manifest) { Rack::Test::UploadedFile.new(File.join(fixture_path, 'coordinates_example_update.csv'), 'text/csv') }
    let(:second_importer) { CalifornicaImporter.new(second_csv_import) }

    it 'updates existing records if the ARK matches' do
      first_importer.import
      work = Work.last
      expect(work.funding_note.first).to eq "Fake Funding Note"
      expect(work.medium.first).to eq "Fake Medium"
      second_importer.import
      work.reload
      expect(work.funding_note.first).to eq "Better Funding Note"
      expect(work.medium).to eq []
    end
  end

  context "importing a CSV" do
    it "adds works to the specified collection" do
      expect(collection.ark).to eq 'ark:/111/222'
      importer.import
      work = Work.last
      expect(work.member_of_collections).to eq [collection]
    end
    it "displays expected fields on show work page" do
      importer.import
      work = Work.last
      expect(work.id).to eq "f62bn833bh-03031"
      visit("/concern/works/#{work.id}")
      expect(page).to have_content "Communion at Plaza Church, Los Angeles, 1942-1952" # title
      expect(page).to have_content "ark:/13030/hb338nb26f" # ark
      expect(page).to have_content "Imhotep" # architect
      expect(page).to have_content "Alternative title" # alternative_title
      expect(page).to have_content "Guadalupe, Our Lady of" # subject
      expect(page).to have_content "Churches--California--Los Angeles" # subject
      expect(page).to have_content "Historic buildings--California--Los Angeles" # $subject: $z has been replaced with --
      expect(page).to have_content "still image" # resource_type
      expect(page).to have_content "copyrighted" # rights_statement
      expect(page).not_to have_link "copyrighted" # Rights statement should not link anywhere
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
      expect(page).to have_content "images" # page_layout
      expect(page).to have_content "Famous Photographer" # photographer
      expect(page).to have_content "Famous Author" # photographer
      expect(page).to have_content "34.05707, -118.239577" # geographic_coordinates, a.k.a. latitude and longitude
      expect(page).to have_content "Los Angeles Daily News Negatives. Department of Special Collections, Charles E. Young Research Library, University of California at Los Angeles." # relation.isPartOf
      expect(page).to have_content "Creative Commons BY Attribution 4.0 International" # License assigned at import time for LADNN collection
      expect(page).to have_content "Place of origin" # place_of_origin
      expect(page).to have_content "Support" # support
      expect(page).to have_content "Summary" # summary
      expect(page).to have_content "Uniform title" # uniform_title
      expect(page).to have_content "clusc_1_1_00010432a.tif" # preservation_copy
    end
    it "displays expected fields on search results page" do
      importer.import
      work = Work.last
      visit("catalog?search_field=all_fields&q=")
      expect(page).to have_content work.title.first
      expect(page).to have_content work.description.first
      expect(page).to have_content work.normalized_date.first
    end
  end
  it "displays expected facets" do
    importer.import
    visit("/catalog?search_field=all_fields&q=")
    facet_headings = page.all(:css, 'h3.facet-field-heading').to_a.map(&:text)
    expect(facet_headings).to contain_exactly("Subject", "Resource Type", "Genre", "Names", "Location", "Normalized Date", "Extent", "Medium", "Dimensions", "Language", "Collection")
  end
end
