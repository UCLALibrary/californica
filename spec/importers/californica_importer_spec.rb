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
      expect(File.readlines(importer.ingest_log_filename).each(&:chomp!).last).to match(/Elapsed time/)
    end

    it "records the number of records ingested" do
      importer.import
      expect(File.read(importer.ingest_log_filename)).to match(/Actually processed 1 records/)
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
      let(:error_record) { instance_double('Darlingtonia::InputRecord') }

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
