# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvRow, type: :model do
  subject(:csv_row) { FactoryBot.create(:csv_row) }

  it 'has a row number' do
    expect(csv_row.row_number).to eq(1)
   end

   it 'has a job id' do
    expect(csv_row.job_id).to eq('23452')
   end
   it 'has a parent csv import record' do
    expect(csv_row.csv_import_id).to eq('193453')
   end

   it 'has a status' do
    expect(csv_row.status).to eq('complete')
   end

   it 'has a error messages' do
    expect(csv_row.error_messages).to eq('here is your error')
   end
 
  it 'has metadata that is parsable as json' do
    metadata_hash = JSON.parse(csv_row.metadata)
    expect(metadata_hash['Item Ark']).to eq('21198/zz001pz6jq')
  end 
end
