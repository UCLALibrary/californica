# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Import and Display a Work', :clean, type: :system, inline_jobs: true, js: true do
  subject(:importer) { CalifornicaImporter.new(csv_import, info_stream: [], error_stream: []) }
  let(:admin_user) { FactoryBot.create(:admin) }
  let(:collection) { Collection.find_or_create_by_ark('ark:/111/222') }

  let(:csv_file)   { File.join(fixture_path, 'coordinates_example.csv') }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest) }
  let(:manifest) { Rack::Test::UploadedFile.new(csv_file, 'text/csv') }
  let(:second_csv_import) { FactoryBot.create(:csv_import, user: user, manifest: second_manifest) }
  let(:second_importer) { CalifornicaImporter.new(second_csv_import, info_stream: [], error_stream: []) }
  let(:second_manifest) { Rack::Test::UploadedFile.new(File.join(fixture_path, 'coordinates_example_update.csv'), 'text/csv') }
  let(:third_csv_import) { FactoryBot.create(:csv_import, user: user, manifest: third_manifest) }
  let(:third_importer) { CalifornicaImporter.new(third_csv_import, info_stream: [], error_stream: []) }
  let(:third_manifest) { Rack::Test::UploadedFile.new(File.join(fixture_path, 'test_example_license.csv'), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }

  before { login_as admin_user }

  it "imports records from a csv" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('IIIF_SERVER_URL').and_return('https://cantaloupe.url/iiif/2/')
    # adds works to the specified collection
    expect(collection.ark).to eq 'ark:/111/222'
    importer.import
    work = Work.last
    expect(work.member_of_collections).to eq [collection]

    # displays expected fields on show work page
    # these should match the value in the spec/fixtures/coordinates_example.csv

    work = Work.last
    expect(work.id).to eq "f62bn833bh-03031"
    visit("/concern/works/#{work.id}")
    expect(page).to have_content "Communion at Plaza Church, Los Angeles, 1942-1952" # title
    expect(page).to have_content "ark:/13030/hb338nb26f" # ark
    expect(page).to have_content "Imhotep" # architect
    expect(page).to have_content "Alternative title" # alternative_title
    expect(page).to have_content "Calligrapher-1"
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
    expect(page).to have_content "Editor-1"
    expect(page).to have_content "Engraver-1"
    expect(page).to have_content "1 photograph" # extent
    expect(page).to have_content "Fake Medium" # medium
    expect(page).to have_content "200x200" # dimensions
    expect(page).to have_content "Fake Funding Note" # funding_note
    expect(page).to have_content "Fake Caption" # caption
    expect(page).to have_content "No linguistic content" # language
    expect(page).to have_content "images" # page_layout
    expect(page).to have_content "paged" # iiif_viewing_hint
    expect(page).to have_content "Famous Photographer" # photographer
    expect(page).to have_content "Famous Author" # photographer
    expect(page).to have_content "34.05707, -118.239577" # geographic_coordinates, a.k.a. latitude and longitude
    expect(page).to have_content "Los Angeles Daily News Negatives. Department of Special Collections, Charles E. Young Research Library, University of California at Los Angeles." # relation.isPartOf
    expect(page).to have_content "Creative Commons BY Attribution 4.0 International" # License assigned at import time for LADNN collection
    expect(page).to have_content "Place of origin" # place_of_origin
    expect(page).to have_content "Support" # support
    expect(page).to have_content "Summary" # summary
    expect(page).to have_content "https://www.library.ucla.edu" # opac_url
    expect(page).to have_content "Binding note" # binding_note
    expect(page).to have_content "left-to-right" # iiif_text_direction
    expect(page).to have_content "Mexican American Catholics" # uniform_title
    expect(page).to have_content "clusc_1_1_00010432a.tif" # preservation_copy
    expect(page).to have_content "iiif-range" # iiif_range
    expect(page).to have_content "illustration-note" # illustrations_note
    expect(page).to have_content "Illustrator-1" # illustrator
    expect(page).to have_content "history-description" # provenance
    expect(page).to have_content "table of contents" # toc
    expect(page).to have_content "concept-topic" # subject_topic
    expect(page).to have_content "descriptive-topic" # subject_topic
    expect(page).to have_content "collated" # collated
    expect(page).to have_content "follated" # follated
    expect(page).to have_content "illuminated" # illuminated
    expect(page).to have_content "also illuminated" # illuminated
    expect(page).to have_content "la la la" # composer
    expect(page).to have_content "Schubert" # composer
    # expect(page).to have_content "Amat-Mamu" # scribe
    expect(page).to have_content "Sin-liqe-unninni" # scribe
    expect(page).to have_content "condition_note" # condtion_note
    expect(page).to have_content "commentator_1" # commentator
    expect(page).to have_content "commentator_2" # commentator
    expect(page).to have_content "translator_1" # translator
    expect(page).to have_content "translator_2" # translator
    expect(page).to have_content "https://fake.url/iiif/ark%3A%2F13030%2Fhb338nb26f" # thumbnail_link
    expect(page).to have_content "subject_geographic_1" # subject_geographic
    expect(page).to have_content "subject_temporal_1" # subject_temporal
    expect(page).to have_content "subject-culturalObject-1" # subject_cultural_object
    expect(page).to have_content "subject-domain-topic-1" # subject_domain_topic
    expect(page).to have_content "colophon_text" # colophon
    expect(page).to have_content "colophon_text_2" # colophon
    expect(page).to have_content "finding_aid_url_1" # finding_aid_url
    expect(page).to have_content "finding_aid_url_2" # finding_aid_url
    expect(page).to have_content "rubricator_1" # rubricator
    expect(page).to have_content "name_creator" # creator
    expect(page).to have_content "Calligrapher-1" # calligrapher
    expect(page).to have_content "Editor-1" # editor
    expect(page).to have_content "Engraver-1" # engraver
    expect(page).to have_content "Note-1" # note
    expect(page).to have_content "Printmaker-1" # print maker
    expect(page).to have_content "contents_note-1" # contents_note
    expect(page).to have_content "Artist" # artist
    expect(page).to have_content "Cartographer-1" # cartographer
    expect(page).to have_content "Disclaimer-1" # content_disclaimer
    expect(page).to have_content "Interviewee-1" # interviewee
    expect(page).to have_content "Interviewer-1" # interviewer
    expect(page).to have_content "Director-1" # director
    expect(page).to have_content "Producer-1" # producer
    expect(page).to have_content "Program-1" # program
    expect(page).to have_content "Recipient-1" # recipient
    expect(page).to have_content "Series-1" # series
    expect(page).to have_content "Host-1" # host
    expect(page).to have_content "Musician-1" # musician
    expect(page).to have_content "Printer-1" # printer
    expect(page).to have_content "Researcher-1" # researcher
    expect(page).to have_content "Statement of Responsibility-1" # resp_statement
    expect(page).to have_content "References-1" # citation_source
    expect(page).to have_content "AdminNote-1" # note_admin
    expect(page).to have_content "Format-1" # format_book
    expect(page).to have_content "Related Records Work ark:/123/456" # human_related_record_title
    expect(page).to have_content "Related Items-1" # related_to
    expect(page).to have_content "Local rights statement-1" # local_rights_statement
    expect(page).to have_content 'Edition-2' # edition
    expect(page).to have_content 'History-1' # history
    expect(page).to have_content 'Identifier-1' # identifier_global

    # displays expected sfields on search results page
    visit("catalog?search_field=all_fields&q=")
    expect(page).to have_content work.title.first
    expect(page).to have_content work.description.first
    expect(page).to have_content work.normalized_date.first

    # displays expected facets
    facet_headings = page.all(:css, 'h3.facet-field-heading').to_a.map(&:text)
    expect(facet_headings).to contain_exactly("Subject", "Creator", "Resource Type", "Genre", "Names", "Location", "Normalized Date", "Extent", "Medium", "Dimensions", "Language", "Collection", "Subject geographic", "Subject temporal", "Repository", "Subject cultural object", "Subject domain topic", "Series", "Host", "Musician", "Printer", "Researcher")

    # importing the same object twice
    expect(work.funding_note.first).to eq "Fake Funding Note"
    expect(work.medium.first).to eq "Fake Medium"
    second_importer.import
    work.reload
    expect(work.funding_note.first).to eq "Better Funding Note"
    expect(work.medium).to eq []
  end

  it "imports records from a csv with license" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('IIIF_SERVER_URL').and_return('https://cantaloupe.url/iiif/2/')

    # adds works to the specified collection
    expect(collection.ark).to eq 'ark:/111/222'
    third_importer.import
    work = Work.last
    expect(work.member_of_collections).to eq [collection]

    # displays expected fields on show work page
    work = Work.last
    expect(work.id).to eq "f62bn833bh-03031"
    visit("/concern/works/#{work.id}")
    expect(page).to have_content "Creative Commons CC0 1.0 Universal" # license
  end
end
