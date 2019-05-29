# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvManifestValidator, type: :model do
  let(:validator) { described_class.new(manifest) }
  let(:manifest) { csv_import.manifest }
  let(:user) { FactoryBot.build(:user) }
  let(:csv_import) do
    import = CsvImport.new(user: user, import_file_path: fixture_path)
    File.open(csv_file) { |f| import.manifest = f }
    import
  end

  context 'a valid CSV file' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'import_manifest.csv') }

    it 'has no errors' do
      expect(validator.errors).to eq []
    end

    it 'has no warnings' do
      expect(validator.warnings).to eq []
    end

    it 'returns the record count' do
      validator.validate
      expect(validator.record_count).to eq 3
    end
  end

  context 'a file that can\'t be parsed' do
    it 'has an error' do
      skip # TODO
    end
  end

  context 'a CSV that is missing required headers' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'missing_title_header.csv') }

    it 'has an error' do
      missing_title_error = 'Missing required column: Title.  Your spreadsheet must have this column.  If you already have this column, please check the spelling and capitalization.'
      validator.validate
      expect(validator.errors).to contain_exactly(missing_title_error)
    end
  end

  context 'a CSV with duplicate headers' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'duplicate_headers.csv') }

    it 'has an error' do
      validator.validate
      expect(validator.errors).to contain_exactly(
        'Duplicate column header: Title (used 2 times). Each column must have a unique header.'
      )
    end
  end

  context 'a CSV that is missing required values' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'missing_values.csv') }

    it 'has warnings' do
      validator.validate
      expect(validator.warnings).to contain_exactly(
        'Can\'t import Row 3: missing "Item ARK".',
        'Can\'t import Row 4: missing "Title".',
        'Can\'t import Row 5: missing "Object Type".',
        'Can\'t import Row 6: missing "Parent ARK".',
        'Row 7: missing \'Rights.copyrightStatus\' will be set to \'unknown\'.',
        'Can\'t import Row 8: missing "File Name".'
      )
    end
  end

  context 'a CSV that has extra headers' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'extra_headers.csv') }

    it 'has a warning' do
      validator.validate
      expect(validator.warnings).to include(
        'The field name "another_header_1" is not supported.  This field will be ignored, and the metadata for this field will not be imported.',
        'The field name "another_header_2" is not supported.  This field will be ignored, and the metadata for this field will not be imported.'
      )
    end
  end

  context 'a CSV with invalid values in controlled-vocabulary fields' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'invalid_values.csv') }

    it 'has warnings' do
      validator.validate
      expect(validator.warnings).to include(
        'Row 2: \'invalid rights statement\' is not a valid value for \'Rights.copyrightStatus\'',
        'Row 3, 4: \'invalid type\' is not a valid value for \'Type.typeOfResource\''
      )
    end
  end

  context 'when the csv has a missing file' do
    let(:csv_file) { 'spec/fixtures/example-missingimage.csv' }

    it 'has warnings' do
      validator.validate
      path = File.join(fixture_path, 'missing_file.tif')
      expect(validator.warnings).to include("Row 2: cannot find '#{path}'")
    end

    it 'doesn\'t warn about files that aren\'t missing' do
      validator.validate
      path = File.join(fixture_path, 'clusc_1_1_00010432a.tif')
      expect(validator.warnings).to_not include("Row 2: cannot find '#{path}'")
    end
  end

  context 'when import_file_path is nil' do
    let(:csv_import) do
      import = CsvImport.new(user: user, import_file_path: nil)
      File.open(csv_file) { |f| import.manifest = f }
      import
    end
    let(:csv_file) { 'spec/fixtures/example-missingimage.csv' }

    it 'doesn\'t warn about missing files' do
      validator.validate
      expect(validator.warnings).to eq []
    end
  end
end
