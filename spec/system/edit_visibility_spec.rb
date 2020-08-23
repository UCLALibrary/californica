# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Edit the visibility for a work', :clean, type: :system, js: true do
  let(:work) { Work.create!(work_attrs) }

  let(:work_attrs) do
    {
      title: ['My Work Title'],
      ark: 'ark:/abc/3456',
      rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'],
      visibility: 'open'
    }
  end

  context 'logged in as an admin user' do
    let(:admin) { FactoryBot.create :admin }
    before { login_as admin }

    scenario 'successfully edits the visibility' do
      visit edit_hyrax_work_path(work)

      # When the form first loads, the correct visibility should be selected
      current_visibility = find(:xpath, '//input[@name = "work[visibility]" and @checked = "checked"]').value
      expect(current_visibility).to eq 'open'

      # We added a new value for visibility that
      # doesn't exist in Hyrax.  Make sure the form
      # has our new value "sinai" as an option
      # for the visibility field.
      # Select "sinai" for the new visibility.
      within('.visibility') do
        choose "Sinai"
      end
      click_on 'Save changes'

      # When the show page loads, it should have the new visibility
      expect(page).to have_content 'Sinai'
      expect(page).to have_current_path(hyrax_work_path(work), ignore_query: true)
    end
  end
end
