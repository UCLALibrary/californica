# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvRow, type: :model do
  subject(:csv_row) { FactoryBot.build(:csv_row) }
  let(:job_id) { "4344db9d-eef0-46c2-a3f6-5ebc19043b76" }
  let(:csv_import_1) { FactoryBot.create(:csv_import) }
  let(:csv_import_2) { FactoryBot.create(:csv_import) }

  it 'has a row number' do
    expect(csv_row.row_number).to be_instance_of(Integer)
  end

  it 'has a job id' do
    expect(csv_row.job_id).to eq('23452')
  end

  it 'has a parent csv import record' do
    expect(csv_row.csv_import_id).to eq('193453')
  end

  it 'has a error messages' do
    csv_row.error_messages << 'another error'
    expect(csv_row.error_messages).to contain_exactly('here is your error', 'another error')
  end

  it 'has a status' do
    expect(csv_row.status).to eq('complete')
  end

  it 'has metadata that is parsable as json' do
    metadata_hash = JSON.parse(csv_row.metadata)
    expect(metadata_hash['Item ARK']).to eq('21198/zz001pz6jq')
  end

  it 'validates uniqueness of row_number and csv_import' do
    expect do
      FactoryBot.create(:csv_row, csv_import_id: csv_import_1.id, row_number: 1234)
      FactoryBot.create(:csv_row, csv_import_id: csv_import_1.id, row_number: 1234)
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Row number row_number and csv_import must be unique together')
  end

  it 'allows the same row_number in different csv_imports' do
    expect do
      FactoryBot.create(:csv_row, csv_import_id: csv_import_1.id, row_number: 1234)
      FactoryBot.create(:csv_row, csv_import_id: csv_import_2.id, row_number: 1234)
    end.not_to raise_error
  end

  context 'tracking background jobs' do
    context 'collecting job ids' do
      it 'collects job ids queued' do
        csv_row.job_ids_queued << job_id
        expect(csv_row.job_ids_queued).to contain_exactly(job_id)
      end

      it 'collects job ids completed' do
        csv_row.job_ids_completed << job_id
        expect(csv_row.job_ids_completed).to contain_exactly(job_id)
      end

      it 'collects job ids errored' do
        csv_row.job_ids_errored << job_id
        expect(csv_row.job_ids_errored).to contain_exactly(job_id)
      end
    end
  end
end
