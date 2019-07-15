# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StartCsvImportJob, :clean, inline_jobs: true do
  let(:csv_file) { File.join(fixture_path, 'csv_import', 'good', 'all_fields.csv') }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest, import_file_path: import_file_path) }
  let(:manifest) { Rack::Test::UploadedFile.new(Rails.root.join(csv_file), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }

  context 'happy path', :clean do
    let(:import_file_path) { File.join(fixture_path, 'images', 'good') }
    it 'imports expected objects' do
      described_class.perform_now(csv_import.id)
      expect(Collection.count).to eq 1
      expect(Work.count).to eq 1
      expect(CsvRow.count).to eq 2
    end
  end
end
