# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Edit an existing work', :clean do
  let(:work) { Work.create!(work_attrs) }

  let(:work_attrs) do
    {
      title: ['Old Title'],
      publisher: ['Old Pub'],
      date_created: ['Old Creation Date'],
      subject: ['Old Subj'],
      language: ['Old Lang'],
      resource_type: ['Image'],
      extent: ['Old Extent'],
      caption: ['Old Cap'],
      dimensions: ['Old Dim'],
      funding_note: ['Old Fund Note']
    }
  end

  context 'logged in as an admin user' do
    let(:admin) { FactoryBot.create :admin }

    before do
      login_as admin
    end

    scenario 'successfully edits the work' do
      visit edit_hyrax_work_path(work.id)

      # When the form first loads, it should contain all the old values
      expect(find_field('Title').value).to eq 'Old Title'
      expect(find_field('Publisher').value).to eq 'Old Pub'
      expect(find_field('Date Created').value).to eq 'Old Creation Date'
      expect(find_field('Subject').value).to eq 'Old Subj'
      expect(find_field('Language').value).to eq 'Old Lang'
      expect(find_field('Resource type').value).to eq ['Image']
      expect(find_field('Extent').value).to eq 'Old Extent'
      expect(find_field('Caption').value).to eq 'Old Cap'
      expect(find_field('Dimensions').value).to eq 'Old Dim'
      expect(find_field('Funding Note').value).to eq 'Old Fund Note'

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
