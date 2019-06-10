# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Status of all CSV Imports', :clean, type: :system, js: true do
  context 'logged in as an admin user' do
    let(:admin_user) { FactoryBot.create(:admin) }
    let(:csv_import) { FactoryBot.create(:csv_import, record_count: 52) }
    let(:csv_row1) { FactoryBot.create(:csv_row, csv_import_id: csv_import.id) }
    let(:csv_row2) { FactoryBot.create(:csv_row, csv_import_id: csv_import.id) }

    before do
      login_as admin_user
      csv_import
      csv_row1
      csv_row2
    end

    it 'starts the import' do
      visit "/csv_imports/#{csv_import.id}"
      expect(page).to have_content csv_import.id
      expect(page).to have_content csv_import.created_at.strftime('%e %b %Y %l:%M %p')
      expect(page).to have_content "complete"
      expect(page).to have_content "52"
      expect(page).to have_content "here is your error"
    end
  end
end
