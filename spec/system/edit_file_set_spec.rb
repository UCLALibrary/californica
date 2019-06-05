# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Edit a FileSet', :clean, type: :system, js: true do
  let(:fs) { FactoryBot.create(:file_set, :public, fs_fields) }
  let(:fs_fields) { { title: ['Hello'] } }

  before do
    # The parent work isn't needed for this test
    allow_any_instance_of(Hyrax::FileSetHelper).to receive(:parent_path).and_return('http://example.com')
    allow_any_instance_of(Hyrax::FileSetsController).to receive(:add_breadcrumb_for_action)
  end

  context 'logged in as an admin user' do
    let(:admin) { FactoryBot.create :admin }
    before { login_as admin }

    scenario 'successfully edits the record' do
      visit edit_hyrax_file_set_path(fs)

      # When the form first loads, the correct visibility should be selected
      click_on 'Permissions'
      current_visibility = find(:xpath, '//input[@name = "file_set[visibility]" and @checked = "checked"]').value
      expect(current_visibility).to eq 'open'

      # Select "discovery" for the new visibility.
      within('.set-access-controls') do
        choose "Discovery"
      end
      click_on 'Save'

      # When the show page loads, it should have the new visibility
      expect(page).to have_current_path(hyrax_file_set_path(fs, locale: I18n.locale))
      expect(page).to have_content 'Discovery'
    end
  end
end
