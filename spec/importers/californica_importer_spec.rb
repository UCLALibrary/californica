# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaImporter, :clean do
  subject(:importer) { described_class.new(file) }
  let(:file)       { File.open(csv_path) }
  let(:csv_path)   { 'spec/fixtures/example.csv' }

  # Cleanup log files after each test run
  after do
    File.delete(importer.ingest_log_filename) if File.exist? importer.ingest_log_filename
    File.delete(importer.error_log_filename) if File.exist? importer.error_log_filename
    File.delete(ENV['MISSING_FILE_LOG']) if File.exist?(ENV['MISSING_FILE_LOG'])
  end

  describe 'CSV import' do
    it 'imports records' do
      expect { importer.import }.to change { Work.count }.by 1
    end

    it 'sets #date_uploaded' do
      importer.import
      expect(Work.last.date_uploaded).not_to be_nil
    end

    it 'enqueues local file attachment job' do
      expect { importer.import }.to have_enqueued_job(IngestLocalFileJob)
    end

    it "has an ingest log" do
      expect(importer.ingest_log).to be_kind_of(Logger)
    end

    it "has an error log" do
      expect(importer.error_log).to be_kind_of(Logger)
    end

    it "records the time it took to ingest" do
      importer.import
      expect(File.readlines(importer.ingest_log_filename).each(&:chomp!).last).to match(/elapsed_time/)
    end

    it "records the number of records ingested" do
      importer.import
      expect(File.read(importer.ingest_log_filename)).to match(/successful_record_count: 1/)
    end

    context 'when the collection doesn\'t exist yet' do
      it 'creates a new collection with a modified ark as the id' do
        importer.import
        new_collection = Collection.first
        expect(new_collection.id).to eq "zz00294nz8-21198"
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

    context 'when the image file is missing' do
      let(:csv_path) { 'spec/fixtures/example-missingimage.csv' }

      it "records missing files" do
        importer.import
        expect(File.readlines(ENV['MISSING_FILE_LOG']).each(&:chomp!).last).to match(/missing_file.tif/)
      end
    end

    context 'when the records error' do
      let(:ldp_error)    { Ldp::PreconditionFailed }
      let(:error_record) { Darlingtonia::InputRecord.from(metadata: metadata, mapper: CalifornicaMapper.new) }
      let(:metadata) do
        {
          'Title' => 'Comet in Moominland',
          'language' => 'English',
          'visibility' => 'open'
        }
      end
      before do
        allow(error_record).to receive(:attributes).and_raise(ldp_error)
        allow(importer.parser).to receive(:records).and_return([error_record])
        allow(importer.parser).to receive(:validate).and_return(true)
      end

      it 'does not ingest the item' do
        expect { importer.import }.not_to change { Work.count }
      end

      it 'logs the errors' do
        importer.import

        expect(File.readlines(importer.error_log_filename).each(&:chomp!))
          .to include(/ERROR.+#{ldp_error}/)
      end
    end
  end
end
