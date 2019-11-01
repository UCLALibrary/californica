# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvRowImportJob, :clean do
  let(:csv_import) { FactoryBot.create(:csv_import) }

  context 'happy path' do
    let(:csv_row) { FactoryBot.create(:csv_row, status: nil, csv_import_id: csv_import.id) }

    it 'can set a status' do
      described_class.perform_now(row_id: csv_row.id)
      csv_row.reload
      expect(csv_row.status).to eq('complete')
    end
  end

  context 'error cases' do
    let(:metadata) do
      {
        "Project Name" => "Ethiopic Manuscripts",
        "Item ARK" => "",
        "Parent ARK" => "21198/zz001pz6h6",
        "Object Type" => "ChildWork"
      }.to_json
    end
    let(:csv_row) { FactoryBot.create(:csv_row, status: nil, metadata: metadata, error_messages: nil, csv_import_id: csv_import.id) }

    it 'records an error state and error messages' do
      described_class.perform_now(row_id: csv_row.id)
      csv_row.reload
      expect(csv_row.status).to eq('error')
      expect(csv_row.error_messages).to contain_exactly 'Cannot set id without a valid ark'
    end
  end

  describe 'finalization_tasks' do
    let(:csv_row) { FactoryBot.create(:csv_row, status: nil, metadata: metadata, error_messages: nil, csv_import_id: csv_import.id) }
    let(:item_ark) { "ark:/1234/sjkdg" }
    let(:import_task) { FactoryBot.build(:csv_import_task, id: 798) }
    let(:metadata) do
      {
        "Project Name" => "Ethiopic Manuscripts",
        "Item ARK" => item_ark,
        "Parent ARK" => parent_ark,
        "Title" => "Titley Title",
        "Object Type" => object_type
      }.to_json
    end
    let(:parent_ark) { "ark:/4567/xyz" }

    before do
      allow(CsvImportTask).to receive(:create).and_return(import_task)
      allow_any_instance_of(CollectionRecordImporter).to receive(:import)
      allow_any_instance_of(ActorRecordImporter).to receive(:import)
      Redis.current.flushall
    end

    context 'when the record is a Collection' do
      let(:object_type) { 'Collection' }

      it 'enqueues a ReindexItemJob for the item' do
        expect do
          described_class.perform_now(row_id: csv_row.id)
        end.to have_enqueued_job(ReindexItemJob).with(item_ark, csv_import_id: csv_import.id)
      end
    end

    context 'when the record is a Work' do
      let(:object_type) { 'Work' }

      it 'does enqueue a ReindexItemJob for the item' do
        expect do
          described_class.perform_now(row_id: csv_row.id)
        end.to have_enqueued_job(ReindexItemJob).with(item_ark, csv_import_id: csv_import.id)
      end
    end

    context 'when the record is a ChildWork' do
      let(:object_type) { 'ChildWork' }

      it 'does enqueue a ReindexItemJob for the item' do
        expect do
          described_class.perform_now(row_id: csv_row.id)
        end.to have_enqueued_job(ReindexItemJob).with(item_ark, csv_import_id: csv_import.id)
      end
    end
  end

  describe '#log_start' do
    let(:csv_row) do
      FactoryBot.create(:csv_row,
                        csv_import_id: csv_import.id,
                        status: nil,
                        ingest_record_start_time: nil)
    end

    let(:job) do
      job = described_class.new
      allow(job).to receive(:csv_row).and_return(csv_row)
      job
    end

    it 'sets status' do
      job.send :log_start
      expect(csv_row.status).to eq 'in progress'
    end

    it 'sets ingest_record_start_time' do
      expect(csv_row.ingest_record_start_time).to be_nil
      job.send :log_start
      expect(csv_row.ingest_record_start_time).not_to be_nil
    end
  end

  describe '#log_end' do
    let(:csv_row) do
      FactoryBot.create(:csv_row,
                        csv_import_id: csv_import.id,
                        status: nil,
                        ingest_record_start_time: Time.current,
                        ingest_record_end_time: nil)
    end

    let(:job) do
      job = described_class.new
      allow(job).to receive(:csv_row).and_return(csv_row)
      job
    end

    let(:service) { Californica::CsvImportService.new(csv_import) }

    before do
      allow(Californica::CsvImportService).to receive(:new).with(csv_import).and_return(service)
      allow(service).to receive(:update_status)
    end

    it 'calls Californica::CsvImportService#update_status' do
      job.send :log_end
      expect(service).to have_received(:update_status)
    end

    it 'sets status' do
      job.send :log_end
      expect(csv_row.status).to eq 'complete'
    end

    it 'sets ingest_record_start_time' do
      expect(csv_row.ingest_record_end_time).to be_nil
      job.send :log_end
      expect(csv_row.ingest_record_end_time).not_to be_nil
    end

    it 'sets ingest_duration' do
      expect(csv_row.ingest_duration).to be_nil
      job.send :log_end
      expect(csv_row.ingest_duration).not_to be_nil
    end
  end
end
