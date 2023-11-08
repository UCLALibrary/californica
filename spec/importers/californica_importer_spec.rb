# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaImporter, :clean, inline_jobs: true do
  subject(:importer) { described_class.new(csv_import, info_stream: [], error_stream: []) }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest) }
  let(:manifest) { Rack::Test::UploadedFile.new(Rails.root.join(csv_path), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }
  let(:csv_path) { 'spec/fixtures/example.csv' }

  describe '#finalize_import' do
    before do
      test_strategy = Flipflop::FeatureSet.current.test!
      test_strategy.switch!(:child_works, true)
      allow(importer.parser).to receive(:order_child_works)
      allow(importer.parser).to receive(:reindex_collections)
    end

    it 'orders child works' do
      importer.finalize_import
      expect(importer.parser).to have_received(:order_child_works)
    end

    it 'reindexes collections' do
      importer.finalize_import
      expect(importer.parser).to have_received(:reindex_collections)
    end
  end

  describe '#log_start' do
    let(:csv_import) { FactoryBot.build(:csv_import, status: 'queued', start_time: nil) }
    let(:importer) { described_class.new(csv_import, error_stream: [], info_stream: []) }
    let(:start_time) { Time.zone.now }

    before do
      allow(Time.zone).to receive(:now).and_return(start_time)
      importer.log_start
    end

    it 'sets the status to "in progress"' do
      expect(csv_import.status).to eq 'in progress'
    end

    it 'records the start_time' do
      expect(csv_import.start_time).to eq start_time.round
    end
  end

  describe '#log_end' do
    let(:csv_import) { FactoryBot.build(:csv_import, status: 'in_progress', start_time: start_time, end_time: nil, elapsed_time: nil, elapsed_time_per_record: nil) }
    let(:importer) { described_class.new(csv_import, error_stream: [], info_stream: []) }
    let(:end_time) { Time.zone.now }
    let(:n_records) { 7 }
    let(:parser) { instance_double('CalifornicaCsvParser', records: instance_double('Array', count: n_records)) }
    let(:start_time) { end_time.round - 21 }

    before do
      allow(Time.zone).to receive(:now).and_return(end_time)
      allow(importer).to receive(:parser).and_return(parser)
      importer.log_end
    end

    it 'sets the status to "complete"' do
      expect(csv_import.status).to eq 'complete'
    end

    it 'records the end_time' do
      expect(csv_import.end_time).to eq end_time.round
    end

    it 'records the elapsed time' do
      expect(csv_import.elapsed_time).to eq 21
    end

    it 'records the elapsed time per record' do
      expect(csv_import.elapsed_time_per_record).to eq 3
    end
  end

  describe 'CSV import' do
    it 'has an import_file_path' do
      expect(importer.import_file_path).to eq csv_import.import_file_path
    end

    it 'imports records' do
      expect { importer.import }
        .to change { Work.count }.by(2)
        .and(change { Collection.count }.by(1))
    end

    it 'sets #date_uploaded' do
      importer.import
      expect(Work.last.date_uploaded).not_to be_nil
    end

    it "records the time it took to ingest" do
      importer.import
      expect(importer.info_stream.join('\n')).to match(/elapsed_time/)
    end

    context 'when the collection doesn\'t exist yet' do
      it 'creates a new collection with a modified ark as the id' do
        importer.import
        new_collection = Collection.first
        expect(new_collection.id).to eq "8zn49200zz-89112"
      end
      it 'creates a new collection and adds the work to it' do
        expect(Collection.count).to eq 0
        expect(Work.count).to eq 0

        importer.import

        expect(Collection.count).to eq 1
        expect(Work.count).to eq 2

        new_collection = Collection.first
        new_work = Work.first

        expect(new_work.member_of_collections).to eq [new_collection]
      end
    end

    context 'when the parent collection already exists' do
      let!(:collection) { Collection.find_or_create_by_ark(ark) }
      let(:ark) { 'ark:/21198/zz00294nz8' }

      it 'adds the work to the existing collection' do
        expect(Collection.count).to eq 1
        expect(Work.count).to eq 0

        importer.import

        expect(Collection.count).to eq 1
        expect(Work.count).to eq 2

        existing_collection = Collection.first
        new_work = Work.first

        expect(new_work.member_of_collections).to eq [existing_collection]
      end
    end

    context 'when there is no parent collection in the CSV' do
      let(:csv_path) { 'spec/fixtures/no_parent_collection.csv' }

      it 'doesn\'t cause any errors' do
        expect(Collection.count).to eq 0
        expect(Work.count).to eq 0

        importer.import

        expect(Collection.count).to eq 0
        expect(Work.count).to eq 1
      end
    end

    describe 'when there is a metadata row for the collection' do
      context 'when the collection row is before the work row' do
        let(:csv_path) { 'spec/fixtures/example_work_with_collection_reverse_order.csv' }
        let(:collection) { Collection.first }

        it 'creates the records' do
          expect { importer.import }
            .to change { Work.count }.to(1)
            .and(change { Collection.count }.to(1))
          expect(collection.title).to eq ['Los Angeles Daily News Negatives']
        end
      end

      context 'when the work row is before the collection row' do
        let(:csv_path) { 'spec/fixtures/example_work_with_collection.csv' }
        let(:collection) { Collection.first }

        it 'creates the records' do
          expect { importer.import }
            .to change { Work.count }.to(1)
            .and(change { Collection.count }.to(1))
          expect(collection.title).to eq ['Los Angeles Daily News Negatives']
        end
      end
    end

    context 'when the job is re-run after a failure' do
      let(:csv_row) { FactoryBot.create(:csv_row, csv_import_id: csv_import.id, row_number: 1, status: 'complete') }

      before do
        csv_row
      end

      it 'skips already-imported CsvRows' do
        allow(CsvRowImportJob).to receive(:perform_now)
        importer.import
        expect(CsvRowImportJob).not_to have_received(:perform_now)
      end
    end
  end
end
