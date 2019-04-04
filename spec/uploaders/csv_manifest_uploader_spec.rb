# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvManifestUploader, type: :model do
  let(:uploader) { csv_import.manifest }
  let(:csv_import) do
    import = CsvImport.new(user: user)
    File.open(csv_file) { |f| import.manifest = f }
    import
  end
  let(:user) { FactoryBot.build(:user) }

  context 'a valid CSV file' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'import_manifest.csv') }

    it 'has no errors' do
      expect(uploader.errors).to eq []
    end

    it 'has no warnings' do
      expect(uploader.warnings).to eq []
    end
  end

  context 'a CSV that has warnings' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'extra_headers.csv') }

    it 'has warning messages' do
      expect(uploader.warnings).to eq [
        'The field name "another_header_1" is not supported.  This field will be ignored, and the metadata for this field will not be imported.',
        'The field name "another_header_2" is not supported.  This field will be ignored, and the metadata for this field will not be imported.'
      ]
    end
  end

  context 'a CSV that has errors' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'missing_title_header.csv') }

    it 'has error messages' do
      expect(uploader.errors).to eq ['Missing required column: "title".  Your spreadsheet must have this column.  If you already have this column, please check the spelling and capitalization.']
    end
  end
end
