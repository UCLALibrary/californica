# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvRowImportJob do
  let(:csv_row) { FactoryBot.create(:csv_row, status: nil) }

  it 'can set a status' do
    described_class.perform_now(row_id: csv_row.id)
    csv_row.reload
    expect(csv_row.status).to eq('complete')
  end
end
