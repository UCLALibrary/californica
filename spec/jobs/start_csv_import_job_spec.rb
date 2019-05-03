# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StartCsvImportJob, :clean, :inline_jobs do
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
      expect(Work.last.members.first.files.first.metadata.mime_type.first).to match(/tiff/)
    end
  end

  context 'a corrupt file', :clean do
    let(:import_file_path) { File.join(fixture_path, 'images', 'corrupted') }
    let(:original_logger) { Rails.logger }
    let(:output) { StringIO.new }

    before do
      original_logger
      Rails.logger = Logger.new(output)
    end

    after do
      Rails.logger = original_logger
    end

    it 'writes a characterization error with expected metadata' do
      described_class.perform_now(csv_import.id)
      expect(Collection.count).to eq 1
      expect(Work.count).to eq 1
      characterization_error = output.string
      expect(characterization_error).to match(/event: unexpected file characterization/)
      expect(characterization_error).to match(/ark: #{Work.last.ark}/)
      expect(characterization_error).to match(/work_id: #{Work.last.id}/)
      expect(characterization_error).to match(/food.tif/)
      # Different versions of FITS return different mime types
      expect(characterization_error).to match(/mime_type: image\/tiff/).or match(/mime_type: application\/octet-stream/)
    end
  end
end
