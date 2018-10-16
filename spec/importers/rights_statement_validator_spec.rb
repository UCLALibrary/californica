# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RightsStatementValidator do
  subject(:validator) { described_class.new(error_stream: []) }

  let(:csv_file) { File.join(fixture_path, 'example-invalid-rights_statement.csv') }
  let(:open_file) { File.open(csv_file) }
  after { open_file.close }

  let(:parser) { CalifornicaCsvParser.new(file: open_file, error_stream: [], info_stream: []) }

  it 'returns errors for invalid rights statements' do
    return_value = validator.validate(parser: parser)
    expect(return_value.map(&:class)).to eq [Darlingtonia::Validator::Error]
    expect(return_value.first.description).to match(/The invalid values are: invalid data/)
  end
end
