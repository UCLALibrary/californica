# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Display a Multipage Manuscript', :clean, :inline_jobs, type: :system, js: true do
  let(:csv_file) { File.join(fixture_path, 'csv_import', 'multipage_mss', 'mss_sample.csv') }
  let(:import_file_path) { File.join(fixture_path, 'images', 'ethiopian_mss').to_s }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest, import_file_path: import_file_path) }
  let(:manifest) { Rack::Test::UploadedFile.new(Rails.root.join(csv_file), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }

  before do
    StartCsvImportJob.perform_now(csv_import.id)
  end

  context "as an admin" do
    it "displays expected fields" do
      login_as user
      work = Work.last
      expect(work.ordered_member_ids).to eq ["rm6zp100zz-89112", "qj6zp100zz-89112", "7k6zp100zz-89112"]
      visit("/concern/works/#{work.id}")
      expect(page).to have_content work.title.first
      expect(page.html).to match(/uv viewer/)
    end
  end
end
