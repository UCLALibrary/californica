# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvImport, type: :model do
  subject(:csv_import) { described_class.new }

  it 'has a CSV manifest' do
    expect(csv_import.manifest).to be_a CsvManifestUploader
  end
end
