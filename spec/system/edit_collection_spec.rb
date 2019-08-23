# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Edit an existing collection', :clean, type: :system, js: true do
  let(:collection) { Collection.create!(collection_attrs) }
  let(:collection) { FactoryBot.create(:collection_lw, user: admin) }
  let(:admin) { FactoryBot.create :admin }

  let(:collection_attrs) do
    {
      title: ['Old Title'],
      architect: ['Old architect'],
      alternative_title: ['alternative title'],
      ark: 'ark:/abc/1234',
      author: ['Old Author'],
      rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'], # "copyrighted"
      publisher: ['Old Pub'],
      date_created: ['Old Creation Date'],
      subject: ['Old Subj'],
      language: ['ang'],
      description: ['Old Desc'],
      resource_type: ['http://id.loc.gov/vocabulary/resourceTypes/col'], # "collection"
      extent: ['Old Extent'],
      caption: ['Old Cap'],
      dimensions: ['Old Dim'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      iiif_viewing_hint: 'Old Iiif viewing hint',
      latitude: ['Old Lat'],
      longitude: ['Old Long'],
      local_identifier: ['Old Local ID'],
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['Old Normalized Date'],
      page_layout: ['Old Page layout'],
      place_of_origin: ['Old Place of origin'],
      repository: ['Old Repository'],
      location: ['Old Loc'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      photographer: ['Old Photographer'],
      services_contact: ['Old Services Contact'],
      binding_note: 'Old Binding note',
      summary: ['Old Summary'],
      subject_topic: ['Old Subject topic'],
      support: ['Old Supprt'],
      iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection', # "left-to-right"
      uniform_title: ['Old Uniform title']
    }
  end

  include_context 'with workflow'

  before do
    # Set all the attributes of collection
    # Normally we'd do this in the FactoryBot factory, but in this case we want
    # to use the Hyrax factories.
    collection_attrs.each do |k, v|
      collection.send((k.to_s + "=").to_sym, v)
    end
    collection.save
  end

  context 'logged in as an admin user' do
    before { login_as admin }

    scenario 'successfully edits the work' do
      visit "/dashboard/collections/#{collection.id}/edit"

      # When the form first loads, it should contain all the old values
      # expect(page.all(:css, 'div.select.work_rights_statement/select').first.text).to eq 'copyrighted'
      expect(first(:css, '#collection_description').value).to eq 'Old Desc'
      click_on 'Additional fields'
      expect(find_field('Publisher').value).to eq 'Old Pub'
      expect(find_field('Date Created').value).to eq 'Old Creation Date'
      expect(find_field('Subject').value).to eq 'Old Subj'
      expect(page).to have_select('Language', selected: 'English, Old (ca. 450-1100)', multiple: true)
      expect(find_field('Resource type').value).to eq ["http://id.loc.gov/vocabulary/resourceTypes/col"]
      expect(find_field('Extent').value).to eq 'Old Extent'
      expect(find_field('Caption').value).to eq 'Old Cap'
      expect(find_field('Dimensions').value).to eq 'Old Dim'
      expect(find_field('Funding Note').value).to eq 'Old Fund Note'
      expect(find_field('Genre').value).to eq 'Old Genre'
      expect(find_field('Latitude').value).to eq 'Old Lat'
      expect(find_field('Longitude').value).to eq 'Old Long'
      expect(find_field('Local Identifier').value).to eq 'Old Local ID'
      expect(find_field('Medium').value).to eq 'Old Medium'
      expect(find_field('Name (Subject)').value).to eq 'Old Name/Subj'
      expect(find_field('Normalized Date').value).to eq 'Old Normalized Date'
      expect(find_field('Page layout').value).to eq 'Old Page layout'
      expect(find_field('Repository').value).to eq 'Old Repository'
      expect(find_field('Place of origin').value).to eq 'Old Place of origin'
      # expect(find_field('Location').value).to eq 'Old Loc'
      expect(find_field('Rights (country of creation)').value).to eq 'Old Rights Country'
      expect(find_field('Rights Holder').value).to eq 'Old Rights Holder'
      expect(find_field('Photographer').value).to eq 'Old Photographer'
      expect(find_field('Rights services contact').value).to eq 'Old Services Contact'
      expect(find_field('Summary').value).to eq 'Old Summary'
      expect(find_field('Binding note').value).to eq 'Old Binding note'
      expect(page).to have_select('Iiif text direction', selected: 'left-to-right', multiple: false)
      expect(find_field('Subject topic').value).to eq 'Old Subject topic'
      expect(find_field('Uniform title').value).to eq 'Old Uniform title'

      #
      # # Edit some fields in the form
      fill_in 'Title', with: 'New Title'
      fill_in 'Description', with: 'New Description'
      fill_in 'Extent', with: 'New Extent'

      click_on 'Save changes'
      expect(page).to have_current_path("/dashboard/collections/#{collection.id}/edit?locale=en")

      # Now the form should have the new values
      expect(page).to     have_content 'New Title'
      expect(page).not_to have_content 'Old Title'
      expect(page).to     have_content 'New Description'
      expect(page).to_not have_content 'Old Desc'
      col = Collection.last
      expect(col.extent).to eq ["New Extent"]
    end
  end
end
