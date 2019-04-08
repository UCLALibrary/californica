# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Importing records from a CSV file', :perform_jobs, :clean, type: :system, js: true do
  let(:csv_file) { File.join(fixture_path, 'csv_import', 'good', 'all_fields.csv') }

  context 'logged in as an admin user' do
    let(:admin_user) { FactoryBot.create(:admin) }

    before do
      allow(CharacterizeJob).to receive(:perform_later) # There is no fits installed on travis-ci
      login_as admin_user
    end

    it 'starts the import' do
      visit new_csv_import_path

      # Fill in and submit the form
      attach_file('csv_import[manifest]', csv_file, make_visible: true)
      expect(page).to have_content("You sucessfully uploaded this CSV: all_fields.csv")
      click_on 'Preview Import'

      expect(page).to have_content 'This import will add XXX new records.'

      # There is a link so the user can cancel.
      expect(page).to have_link 'Cancel', href: new_csv_import_path(locale: I18n.locale)

      # After reading the warnings, the user decides
      # to continue with the import.
      click_on 'Start Import'
    end
  end
end
