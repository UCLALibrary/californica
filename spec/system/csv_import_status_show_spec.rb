# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Status of all CSV Imports', :clean, type: :system, js: true do
  context 'logged in as an admin user' do
    ENV["TZ"]
    ENV["TZ"] = "America/Los_Angeles"
    Time.zone = "America/Los_Angeles"
    let(:admin_user) { FactoryBot.create(:admin) }
    let(:csv_import) { FactoryBot.create(:csv_import, record_count: 3) }
    let(:csv_row1) { FactoryBot.create(:csv_row, csv_import_id: csv_import.id, ingest_duration: 0.869, object_type: 'Collection', no_of_children: 2, ingest_record_start_time: '23 Oct 2019 12:04:01:491 PM', ingest_record_end_time: '23 Oct 2019 12:04:01:501 PM') }
    let(:csv_row2) { FactoryBot.create(:csv_row, csv_import_id: csv_import.id, ingest_duration: 2.181, object_type: 'Work', no_of_children: 0) }
    let(:csv_row3) { FactoryBot.create(:csv_row, csv_import_id: csv_import.id, ingest_duration: 1.039, object_type: 'Work', no_of_children: 0) }

    before do
      login_as admin_user
      csv_import
      csv_row1
      csv_row2
      csv_row3
    end

    it 'starts the import' do
      visit "/csv_imports/#{csv_import.id}"
      expect(page).to have_content csv_import.id
      expect(page).to have_content 'complete'
      expect(page).to have_content '3'
      expect(page).to have_content 'here is your error'
      expect(page).to have_content 'Current row count'
      expect(page).to have_content '(Refresh page to view updated ingest)'
      expect(page).to_not have_content 'Puppy'
      expect(page).to have_content 'Minimum'
      expect(page).to have_content 'Maximum'
      expect(page).to have_content 'Mean'
      expect(page).to have_content 'Median'
      expect(page).to have_content 'Standard deviation'
      expect(page).to have_content 'Object Type'
      expect(page).to have_content 'Children'
      expect(page).to have_content 0.87 # min
      expect(page).to have_content 2.18 # max
      expect(page).to have_content 1.36 # mean/average 1.36
      expect(page).to have_content 1.04 # median
      expect(page).to have_content 0.58 # std_deviation
      expect(page).to have_content 'Work'
      expect(page).to have_content '0'
      expect(page).to have_content 'Start Time'
      expect(page).to have_content 'End Time'
    end
  end
end
