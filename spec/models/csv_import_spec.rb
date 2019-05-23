# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvImport, type: :model do
  subject(:csv_import) { described_class.new(csv_rows: [CsvRow.new]) }
  
  it 'has a CSV manifest' do
    expect(csv_import.manifest).to be_a CsvManifestUploader
  end

  it 'has CSV rows' do
    expect(csv_import.csv_rows.map(&:class)).to eq([CsvRow]) 
  end

  it 'has a import_file_path' do
    path = "/opt/data/whatever"
    csv_import.import_file_path = path
    expect(csv_import.import_file_path).to eq path
  end
end
