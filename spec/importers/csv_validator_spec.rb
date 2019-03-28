# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvValidator do
  subject(:validator) { described_class.new(error_stream: []) }

  let(:open_file) { File.open(csv_file) }
  after { open_file.close }

  let(:parser) { CalifornicaCsvParser.new(file: open_file, error_stream: [], info_stream: []) }

  context 'a CSV with no known problems' do
    let(:csv_file) { File.join(fixture_path, 'example.csv') }
    it 'has no errors' do
      errors = validator.validate(parser: parser)
      expect(errors).to eq []
    end
  end

  context 'when the CSV file is missing required headers' do
    let(:csv_file) { File.join(fixture_path, 'missing_headers.csv') }

    it 'has errors for missing headers' do
      errors = validator.validate(parser: parser)
      expect(errors.map(&:class)).to eq [Darlingtonia::Validator::Error]
      expect(errors.map(&:description)).to eq ['Missing required columns in CSV file: Title, Item Ark']
    end
  end

  context 'when the CSV has unrecognized headers' do
    let(:csv_file) { File.join(fixture_path, 'unknown_headers.csv') }

    it 'has errors' do
      errors = validator.validate(parser: parser)
      expect(errors.map(&:class)).to eq [Darlingtonia::Validator::Error]
      expect(errors.map(&:description)).to eq ['The CSV file contains unknown columns: Format.EXTENT, Unknown column, Another column']
    end
  end
end
