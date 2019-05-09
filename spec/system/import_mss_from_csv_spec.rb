# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Importing a multi-page mss from a CSV file', :clean, type: :system, js: true do
  let(:csv_file) { File.join(fixture_path, 'csv_import', 'multipage_mss', 'mss_sample.csv') }
  let(:import_file_path) { File.join(fixture_path, 'images', 'ethiopian_mss').to_s }

  context 'logged in as an admin user' do
    let(:admin_user) { FactoryBot.create(:admin) }

    before do
      login_as admin_user
    end

    it 'starts the import' do
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.map { |a| a[:job] }).not_to include(StartCsvImportJob)
      visit new_csv_import_path
      # Fill in and submit the form
      attach_file('csv_import[manifest]', csv_file, make_visible: true)
      expect(page).to have_content("You sucessfully uploaded this CSV: mss_sample.csv")
      fill_in('import-file-path', with: import_file_path)

      click_on 'Preview Import'

      expect(page).to have_content 'This import will add 5 new records.'

      # There is a link so the user can cancel.
      expect(page).to have_link 'Cancel', href: new_csv_import_path(locale: I18n.locale)

      # After reading the warnings, the user decides
      # to continue with the import.
      click_on 'Start Import'
      expect(page).to have_content('Importing Records from a CSV File')

      csv_import = CsvImport.last
      expect(csv_import.import_file_path).to eq import_file_path
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.map { |a| a[:job] }).to include(StartCsvImportJob)
    end
  end
end
