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
      caption: ['Old Cap'],
      collation: 'Old Collation',
      composer: ['Old Composer'],
      rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'], # "copyrighted"
      publisher: ['Old Pub'],
      date_created: ['Old Creation Date'],
      description: ['Old Desc'],
      dimensions: ['Old Dim'],
      resource_type: ['http://id.loc.gov/vocabulary/resourceTypes/col'], # "collection"
      extent: ['Old Extent'],
      foliation: 'Old Foliation note',
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      iiif_manifest_url: 'https://www.w3.org/TR/2019/WD-appmanifest-20190821/',
      iiif_viewing_hint: 'Old Iiif viewing hint',
      iiif_range: 'Old IIIF Range',
      illuminator: ['Old Illuminator'],
      illustrations_note: ['Old Illustrations note'],
      language: ['ang'],
      latitude: ['Old Lat'],
      longitude: ['Old Long'],
      local_identifier: ['Old Local ID'],
      lyricist: ['Old Lyricist'],
      masthead_parameters: 'Old Masthead Parameters',
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['1900/1901'],
      page_layout: ['Old Page layout'],
      place_of_origin: ['Old Place of origin'],
      provenance: ['Old Provenance'],
      repository: ['Old Repository'],
      location: ['Old Loc'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      photographer: ['Old Photographer'],
      services_contact: ['Old Services Contact'],
      opac_url: 'https://www.library.ucla.edu',
      binding_note: 'Old Binding note',
      scribe: ['Old Scribe'],
      subject: ['Old Subj'],
      subject_topic: ['Old Subject Topic'],
      summary: ['Old Summary'],
      support: ['Old Supprt'],
      toc: ['Old Table of Contents'],
      iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection', # "left-to-right"
      uniform_title: ['Old Uniform title'],
      condition_note: 'Old Condition note',
      representative_image: 'Old Representative image',
      featured_image: 'Old Featured image',
      tagline: 'Old Tagline',
      commentator: ['Old Commentator'],
      subject_geographic: ['Old Subject geographic'],
      subject_temporal: ['Old Subject temporal'],
      translator: ['Old Translator'],
      colophon: ['Old Colophon'],
      finding_aid_url: ['Old Finding aid url'],
      rubricator: ['Old rubricator'],
      creator: ['Old name creator'],
      license: ['http://creativecommons.org/publicdomain/zero/1.0/']
      # local_rights_statement: ['Old Rights statement local'] # This invokes License renderer from hyrax gem
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
      expect(find_field('Iiif manifest url').value).to eq 'https://www.w3.org/TR/2019/WD-appmanifest-20190821/'
      expect(find_field('Iiif range').value).to eq 'Old IIIF Range'
      expect(find_field('Illustrations note').value).to eq 'Old Illustrations note'
      expect(find_field('Latitude').value).to eq 'Old Lat'
      expect(find_field('Longitude').value).to eq 'Old Long'
      expect(find_field('Local Identifier').value).to eq 'Old Local ID'
      expect(find_field('Medium').value).to eq 'Old Medium'
      expect(find_field('Name (Subject)').value).to eq 'Old Name/Subj'
      expect(find_field('Normalized Date').value).to eq '1900/1901'
      expect(find_field('Page layout').value).to eq 'Old Page layout'
      expect(find_field('Provenance').value).to eq 'Old Provenance'
      expect(find_field('Repository').value).to eq 'Old Repository'
      expect(find_field('Place of origin').value).to eq 'Old Place of origin'
      # expect(find_field('Location').value).to eq 'Old Loc'
      expect(find_field('Rights (country of creation)').value).to eq 'Old Rights Country'
      expect(find_field('Rights Holder').value).to eq 'Old Rights Holder'
      expect(find_field('Photographer').value).to eq 'Old Photographer'
      expect(find_field('Summary').value).to eq 'Old Summary'
      expect(find_field('Rights services contact').value).to eq 'Old Services Contact'
      expect(find_field('Toc').value).to eq 'Old Table of Contents'
      expect(find_field('Subject topic').value).to eq 'Old Subject Topic'
      expect(find_field('Opac url').value).to eq 'https://www.library.ucla.edu'
      expect(find_field('Binding note').value).to eq 'Old Binding note'
      expect(page).to have_select('Iiif text direction', selected: 'left-to-right', multiple: false)
      expect(find_field('Uniform title').value).to eq 'Old Uniform title'
      expect(find_field('Collation').value).to eq 'Old Collation'
      expect(find_field('Composer').value).to eq 'Old Composer'
      expect(find_field('Foliation').value).to eq 'Old Foliation note'
      expect(find_field('Lyricist').value).to eq 'Old Lyricist'
      expect(find_field('Illuminator').value).to eq 'Old Illuminator'
      expect(find_field('Masthead').value).to eq 'Old Masthead Parameters'
      expect(find_field('Scribe').value).to eq 'Old Scribe'
      expect(find_field('Condition note').value).to eq 'Old Condition note'
      expect(find_field('Representative image').value).to eq 'Old Representative image'
      expect(find_field('Featured image').value).to eq 'Old Featured image'
      expect(find_field('Tagline').value).to eq 'Old Tagline'
      expect(find_field('Commentator').value).to eq 'Old Commentator'
      expect(find_field('Subject temporal').value).to eq 'Old Subject temporal'
      expect(find_field('Subject geographic').value).to eq 'Old Subject geographic'
      expect(find_field('Translator').value).to eq 'Old Translator'
      expect(find_field('Colophon').value).to eq 'Old Colophon'
      expect(find_field('Finding aid url').value).to eq 'Old Finding aid url'
      expect(find_field('Rubricator').value).to eq 'Old rubricator'
      expect(find_field('Creator').value).to eq 'Old name creator'
      expect(page).to have_select('License', selected: 'Creative Commons CC0 1.0 Universal', multiple: false)
      # expect(find_field('Local rights statement').value).to eq 'Old Rights statement local'
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
