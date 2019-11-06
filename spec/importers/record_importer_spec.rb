# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ::RecordImporter, :clean do
  subject(:importer) { described_class.new(error_stream: [], info_stream: [], attributes: { deduplication_field: 'ark' }) }

  context 'when there isn\'t already a CsvRow' do
    let(:mapper) { instance_double('CalifornicaMapper', metadata: {}, row_number: 1234, object_type: 'Work') }
    let(:record) { instance_double("Darlingtonia::InputRecord", mapper: mapper) }

    before { allow(importer).to receive(:count_children) }

    it 'creates a CsvRow object' do
      allow(CsvRow).to receive(:create)
      importer.import(record: record)
      expect(CsvRow).to have_received(:create)
    end

    it 'sets the CsvRow status to "queued"' do
      importer.import(record: record)
      expect(CsvRow.find_by(csv_import_id: importer.batch_id, row_number: mapper.row_number).status).to eq 'queued'
    end
  end

  context 'when a CsvRow object has already been created' do
    let(:mapper) { instance_double('CalifornicaMapper', metadata: {}, row_number: 1234, object_type: 'Work') }
    let(:record) { instance_double("Darlingtonia::InputRecord", mapper: mapper) }

    before do
      allow(importer).to receive(:count_children)
      FactoryBot.create(:csv_row, status: 'complete', csv_import_id: importer.batch_id, row_number: mapper.row_number)
    end

    it 'preserves the old CsvRow and its status' do
      importer.import(record: record)
      expect(CsvRow.find_by(csv_import_id: importer.batch_id, row_number: mapper.row_number).status).to eq 'complete'
    end
  end

  context 'with counts from different importers' do
    before do
      # Stub out some fake results
      allow_any_instance_of(CollectionRecordImporter).to receive(:success_count).and_return(3)
      allow_any_instance_of(ActorRecordImporter).to receive(:success_count).and_return(1)
      allow_any_instance_of(CollectionRecordImporter).to receive(:failure_count).and_return(4)
      allow_any_instance_of(ActorRecordImporter).to receive(:failure_count).and_return(6)
    end

    it 'sums together the success counts' do
      expect(importer.success_count).to eq 4
    end

    it 'sums together the failure counts' do
      expect(importer.failure_count).to eq 10
    end
  end
end
