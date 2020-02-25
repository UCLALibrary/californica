# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Edit an existing work', :clean, type: :system, js: true do
  let(:work) { Work.create!(work_attrs) }

  let(:work_attrs) do
    {
      access_copy: 'dlmasters/ethiopian/masters/abc123.tif',
      alternative_title: ['Alternative title'],
      architect: ['Old Architect'],
      ark: 'ark:/abc/3456',
      author: ['Old Author'],
      caption: ['Old Caption'],
      contributor: ['Old Contributor'],
      creator: ['Old Creator'],
      date_created: ['Old Creation Date'],
      description: ['Old Desc'],
      dimensions: ['Old Dim'],
      extent: ['Old Extent'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      iiif_manifest_url: 'https://www.w3.org/TR/2019/WD-appmanifest-20190821/',
      iiif_viewing_hint: 'Old Iiif viewing hint',
      iiif_range: 'Old Iiif range',
      illustrations_note: ['Old Illustrations note'],
      language: ['ang'],
      latitude: ['Old Lat'],
      local_identifier: ['Old Local ID'],
      location: ['Old Loc'],
      longitude: ['Old Long'],
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['Old Normalized Date'],
      page_layout: ['Old Page layout'],
      photographer: ['Old Photographer'],
      place_of_origin: ['Old Place of origin'],
      preservation_copy: 'dlmasters/ethiopian/masters/abc123.tif',
      provenance: ['Old Provenance'],
      publisher: ['Old Pub'],
      repository: ['Old Repository'],
      resource_type: ['http://id.loc.gov/vocabulary/resourceTypes/img'], # "image"
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'], # "copyrighted"
      subject: ['Old Subj'],
      summary: ['Old Summary'],
      subject_topic: ['Old Subject topic'],
      binding_note: 'Old Binding note',
      support: ['Old Support'],
      iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection', # "left-to-right"
      title: ['Old Title'],
      toc: ['Old Table of contents'],
      uniform_title: ['Old Uniform title'],
      collation: 'Old Collation',
      composer: ['Old Composer'],
      foliation: 'Old Foliation note',
      illuminator: ['Old Illuminator'],
      lyricist: ['Old Lyricist'],
      scribe: ['Old Scribe'],
      condition_note: 'Old Condition note',
      masthead_parameters: 'Old Masthead Parameters',
      representative_image: 'Old Representative image',
      featured_image: 'Old Featured image',
      tagline: 'Old Tagline',
      commentator: ['Old Commentator'],
      subject_temporal: ['Old Subject temporal'],
      translator: ['Old Translator'],
      # local_rights_statement: ['Old Rights statement local'] # This invokes License renderer from hyrax gem
    }
  end

  include_context 'with workflow'

  context 'logged in as an admin user' do
    let(:admin) { FactoryBot.create :admin }

    before { login_as admin }

    scenario 'successfully edits the work' do
      visit edit_hyrax_work_path(work.id)

      # When the form first loads, it should contain all the old values
      expect(find_field('Title').value).to eq 'Old Title'
      expect(find_field('Ark').value).to eq 'ark:/abc/3456'
      expect(page.all(:css, 'div.select.work_rights_statement').first.has_content?('copyrighted')).to eq true

      click_on 'Additional fields'
      expect(find_field('Access copy').value).to eq 'dlmasters/ethiopian/masters/abc123.tif'
      expect(find_field('Alternative title').value).to eq 'Alternative title'
      expect(find_field('Architect').value).to eq 'Old Architect'
      expect(find_field('Author').value).to eq 'Old Author'
      expect(find_field('Caption').value).to eq 'Old Caption'
      expect(find_field('Date Created').value).to eq 'Old Creation Date'
      expect(find_field('Dimensions').value).to eq 'Old Dim'
      expect(find_field('Extent').value).to eq 'Old Extent'
      expect(find_field('Funding Note').value).to eq 'Old Fund Note'
      expect(find_field('Genre').value).to eq 'Old Genre'
      expect(page).to have_select('Language', selected: 'English, Old (ca. 450-1100)', multiple: true)
      expect(find_field('Iiif manifest url').value).to eq 'https://www.w3.org/TR/2019/WD-appmanifest-20190821/'
      expect(find_field('Latitude').value).to eq 'Old Lat'
      expect(find_field('Local Identifier').value).to eq 'Old Local ID'
      expect(find_field('Location').value).to eq 'Old Loc'
      expect(find_field('Longitude').value).to eq 'Old Long'
      expect(find_field('Medium').value).to eq 'Old Medium'
      expect(find_field('Name (Subject)').value).to eq 'Old Name/Subj'
      expect(find_field('Normalized Date').value).to eq 'Old Normalized Date'
      expect(find_field('Page layout').value).to eq 'Old Page layout'
      expect(find_field('Photographer').value).to eq 'Old Photographer'
      expect(find_field('Place of origin').value).to eq 'Old Place of origin'
      expect(find_field('Preservation copy').value).to eq 'dlmasters/ethiopian/masters/abc123.tif'
      expect(find_field('Publisher').value).to eq 'Old Pub'
      expect(find_field('Repository').value).to eq 'Old Repository'
      expect(find_field('Resource type').value).to eq ['http://id.loc.gov/vocabulary/resourceTypes/img']
      expect(find_field('Rights (country of creation)').value).to eq 'Old Rights Country'
      expect(find_field('Rights Holder').value).to eq 'Old Rights Holder'
      expect(find_field('Subject').value).to eq 'Old Subj'
      expect(find_field('Subject topic').value).to eq 'Old Subject topic'
      expect(find_field('Summary').value).to eq 'Old Summary'
      expect(find_field('Binding note').value).to eq 'Old Binding note'
      expect(page).to have_select('Iiif text direction', selected: 'left-to-right', multiple: false)
      expect(find_field('Uniform title').value).to eq 'Old Uniform title'
      expect(first(:css, '#work_description').value).to eq 'Old Desc'
      expect(find_field('Collation').value).to eq 'Old Collation'
      expect(find_field('Composer').value).to eq 'Old Composer'
      expect(find_field('Foliation').value).to eq 'Old Foliation note'
      expect(find_field('Lyricist').value).to eq 'Old Lyricist'
      expect(find_field('Illuminator').value).to eq 'Old Illuminator'
      expect(find_field('Scribe').value).to eq 'Old Scribe'
      expect(find_field('Condition note').value).to eq 'Old Condition note'
      expect(find_field('Masthead parameters').value).to eq 'Old Masthead Parameters'
      expect(find_field('Representative image').value).to eq 'Old Representative image'
      expect(find_field('Featured image').value).to eq 'Old Featured image'
      expect(find_field('Tagline').value).to eq 'Old Tagline'
      expect(find_field('Commentator').value).to eq 'Old Commentator'
      expect(find_field('Subject temporal').value).to eq 'Old Subject temporal'
      expect(find_field('Translator').value).to eq 'Old Translator'
      # expect(find_field('Local rights statement').value).to eq 'Old Rights statement local'

      # Edit some fields in the form
      fill_in 'Title', with: 'New Title'
      fill_in 'Dimensions', with: 'New Dim'
      fill_in 'Ark', with: 'ark:/not/myark' # This field is read-only and an attempt to change it should not result in a change

      # Submit the form.  When the page reloads, it should be on the show page.
      click_on 'Save changes'
      expect(page).to have_current_path(hyrax_work_path(work.id, locale: I18n.locale))

      # When the show page loads, it should have the new values
      expect(page).to     have_content 'New Title'
      expect(page).to_not have_content 'Old Title'
      expect(page).to     have_content 'New Dim'
      expect(page).to_not have_content 'Old Dim'
      expect(page).to     have_content 'ark:/abc/3456'
      expect(page).to_not have_content 'ark:/not/myark'
    end
  end
end
