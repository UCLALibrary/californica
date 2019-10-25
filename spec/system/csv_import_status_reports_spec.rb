# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Status of all CSV Imports', :clean, type: :system, js: true do
  context 'logged in as an admin user' do
    let(:admin_user) { FactoryBot.create(:admin) }
    let(:csv_import) { FactoryBot.create(:csv_import, record_count: 52) }

    before do
      login_as admin_user
      csv_import
    end

    it 'starts the import' do
      visit '/csv_imports'
      expect(page).to have_content csv_import.id
      expect(page).to have_content csv_import.manifest.filename
      expect(page).to have_content "complete"
      expect(page).to have_content "52"
    end
  end
end
