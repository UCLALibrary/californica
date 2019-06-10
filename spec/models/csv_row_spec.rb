# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvRow, type: :model do
  subject(:csv_row) { FactoryBot.create(:csv_row) }
  let(:job_id) { "4344db9d-eef0-46c2-a3f6-5ebc19043b76" }

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

  it 'has metadata that is parsable as json' do
    metadata_hash = JSON.parse(csv_row.metadata)
    expect(metadata_hash['Item ARK']).to eq('21198/zz001pz6jq')
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
    context 'determining status' do
      it 'has an error status if any job ids are in an error state' do
        csv_row.job_ids_errored << job_id
        expect(csv_row.status).to eq "error"
      end
      it 'has a queued status if there are ids queued but not yet complete' do
        csv_row.job_ids_queued << job_id
        expect(csv_row.status).to eq "queued"
      end
      it 'has a complete status if all job ids queued have registered as complete' do
        csv_row.job_ids_queued << job_id
        csv_row.job_ids_completed << job_id
        expect(csv_row.status).to eq "complete"
      end
    end
  end
end
