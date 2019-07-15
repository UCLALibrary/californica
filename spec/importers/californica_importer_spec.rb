# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaImporter, :clean, inline_jobs: true do
  subject(:importer) { described_class.new(csv_import, info_stream: [], error_stream: []) }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest) }
  let(:manifest) { Rack::Test::UploadedFile.new(Rails.root.join(csv_path), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }
  let(:csv_path) { 'spec/fixtures/example.csv' }

  # Cleanup log files after each test run
  after do
    File.delete(ENV['MISSING_FILE_LOG']) if File.exist?(ENV['MISSING_FILE_LOG'])
  end

  describe 'CSV import' do
    it 'has an import_file_path' do
      expect(importer.import_file_path).to eq csv_import.import_file_path
    end

    it 'imports records' do
      expect { importer.import }
        .to change { Work.count }.by(1)
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
        expect(Work.count).to eq 1

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
        expect(Work.count).to eq 1

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

    context 'when the image file is missing' do
      let(:csv_path) { 'spec/fixtures/example-missingimage.csv' }

      it "records missing files" do
        importer.import
        expect(File.readlines(ENV['MISSING_FILE_LOG']).each(&:chomp!).last).to match(/missing_file.tif/)
      end
    end
  end
end
