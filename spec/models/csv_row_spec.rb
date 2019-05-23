# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvRow, type: :model do
  subject(:csv_row) do 
    described_class.new(
    row_number: 1,
    job_id: '23452',
    csv_import_id: '193453',
    status: 'complete',
    error_messages: 'here is your error',
    metadata: '{ title: "My Title" }'
    )
  end 

  it 'has a row number' do
    expect(csv_row.row_number).to eq(1)
   end

   it 'has a job id' do
    expect(csv_row.job_id).to eq('23452')
   end
   it 'has a parent csv import record' do
    expect(csv_row.csv_import_id).to eq('193453')
   end
   it 'has a error messages' do
    expect(csv_row.error_messages).to eq('here is your error')
   end
 
  it 'has metadata' do
    expect(csv_row.metadata).to eq('{ title: "My Title" }')
  end
end
