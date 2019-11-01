# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::CsvImportService do
  let(:csv_import) do
    csv_import = FactoryBot.create(:csv_import)
    FactoryBot.create(:csv_row, csv_import_id: csv_import.id, metadata: '{"Item ARK": "ark:/abc/123456"}')
    FactoryBot.create(:csv_row, csv_import_id: csv_import.id, metadata: '{"Item ARK": "ark:/abc/654321"}')
    FactoryBot.create(:csv_row, csv_import_id: csv_import.id, metadata: '{"Item ARK": "ark:/abc/918274"}')
    csv_import
  end
  let(:service) { described_class.new csv_import }
  let(:expected_csv) do
    <<~HEREDOC
      Object Type,Title,Item ARK,Parent ARK,Rights.copyrightStatus,File Name,Import Status
      Work,Apple,ark:/abc/123456,ark:/abc/7890123,copyrighted,clusc_1_1_00010432a.tif,queued
      Work,Banana,ark:/abc/654321,ark:/abc/7890123,copyrighted,clusc_1_1_00010432a.tif,error
      Work,Mango,ark:/abc/918274,ark:/abc/7890123,copyrighted,clusc_1_1_00010432a.tif,complete
    HEREDOC
  end

  describe '#csv' do
    before do
      allow(csv_import.csv_rows[0]).to receive(:status).and_return('queued')
      allow(csv_import.csv_rows[1]).to receive(:status).and_return('error')
      allow(csv_import.csv_rows[2]).to receive(:status).and_return('complete')
    end

    it 'appends each row\'s import status' do
      expect(service.csv.to_s).to match expected_csv
    end
  end

  describe '#update_status' do
    let(:csv_import) do
      csv_import = FactoryBot.create(:csv_import,
                                     status: 'in progress',
                                     start_time: Time.zone.parse('1980-09-21 12:05:00'),
                                     record_count: 3)
      FactoryBot.create(:csv_row,
                        csv_import_id: csv_import.id,
                        metadata: '{"Item ARK": "ark:/abc/123456"}',
                        ingest_record_end_time: Time.zone.parse('1980-09-21 12:05:14'),
                        status: 'complete')
      FactoryBot.create(:csv_row,
                        csv_import_id: csv_import.id,
                        metadata: '{"Item ARK": "ark:/abc/654321"}',
                        ingest_record_end_time: Time.zone.parse('1980-09-21 12:05:18'),
                        status: 'complete')
      FactoryBot.create(:csv_row,
                        csv_import_id: csv_import.id,
                        metadata: '{"Item ARK": "ark:/abc/918274"}',
                        ingest_record_end_time: Time.zone.parse('1980-09-21 12:05:15'),
                        status: 'complete')
      FactoryBot.create(:csv_import_task,
                        csv_import_id: csv_import.id,
                        end_timestamp: Time.zone.parse('1980-09-21 12:05:16'),
                        job_status: 'complete')
      FactoryBot.create(:csv_import_task,
                        csv_import_id: csv_import.id,
                        end_timestamp: Time.zone.parse('1980-09-21 12:05:45'),
                        job_status: 'complete')
      FactoryBot.create(:csv_import_task,
                        csv_import_id: csv_import.id,
                        end_timestamp: Time.zone.parse('1980-09-21 12:05:16'),
                        job_status: 'complete')
      csv_import
    end

    it 'sets the status' do
      service.update_status
      expect(csv_import.status).to eq 'complete'
    end

    it 'sets the end_time' do
      service.update_status
      expect(csv_import.end_time).to eq Time.zone.parse('1980-09-21 12:05:45')
    end

    it 'calculates elapsed_time' do
      service.update_status
      expect(csv_import.elapsed_time).to eq 45
    end

    it 'calculates elapsed_time_per_record' do
      service.update_status
      expect(csv_import.elapsed_time_per_record).to eq 15
    end

    context 'when a CsvRow is not complete' do
      before do
        FactoryBot.create(:csv_row,
                          csv_import_id: csv_import.id,
                          metadata: '{"Item ARK": "ark:/abc/2468"}',
                          status: 'in progress',
                          ingest_record_end_time: Time.zone.parse('1980-09-21 12:05:18'))
      end

      it 'does not update the CsvImport' do
        service.update_status
        expect(csv_import.status).to eq 'in progress'
      end
    end

    context 'when a CsvImportTask is incomplete'
  end
end
