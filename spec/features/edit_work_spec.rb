# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Edit an existing work', :clean do
  let(:work) { Work.create!(work_attrs) }

  let(:work_attrs) do
    {
      title: ['Old Title'],
      rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'], # "copyrighted"
      publisher: ['Old Pub'],
      date_created: ['Old Creation Date'],
      subject: ['Old Subj'],
      language: ['Old Lang'],
      description: ['Old Desc'],
      resource_type: ['Image'],
      extent: ['Old Extent'],
      caption: ['Old Cap'],
      dimensions: ['Old Dim'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      latitude: ['Old Lat'],
      longitude: ['Old Long'],
      local_identifier: ['Old Local ID'],
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['Old Normalized Date'],
      repository: ['Old Repository'],
      location: ['Old Loc'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder']
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
      expect(page.all(:css, 'div.select.work_rights_statement/select').first.text).to eq 'copyrighted'
      expect(first(:css, '#work_description').value).to eq 'Old Desc'
      expect(find_field('Publisher').value).to eq 'Old Pub'
      expect(find_field('Date Created').value).to eq 'Old Creation Date'
      expect(find_field('Subject').value).to eq 'Old Subj'
      expect(find_field('Language').value).to eq 'Old Lang'
      expect(find_field('Resource type').value).to eq ['Image']
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
      expect(find_field('Date').value).to eq 'Old Normalized Date'
      expect(find_field('Repository').value).to eq 'Old Repository'
      expect(find_field('Location').value).to eq 'Old Loc'
      expect(find_field('Rights (country of creation)').value).to eq 'Old Rights Country'
      expect(find_field('Rights Holder').value).to eq 'Old Rights Holder'

      # Edit some fields in the form
      fill_in 'Title', with: 'New Title'
      fill_in 'Dimensions', with: 'New Dim'

      # Submit the form.  When the page reloads, it should be on the show page.
      click_on 'Save changes'
      expect(page).to have_current_path(hyrax_work_path(work.id, locale: I18n.locale))

      # When the show page loads, it should have the new values
      expect(page).to     have_content 'New Title'
      expect(page).to_not have_content 'Old Title'
      expect(page).to     have_content 'New Dim'
      expect(page).to_not have_content 'Old Dim'
    end
  end
end
