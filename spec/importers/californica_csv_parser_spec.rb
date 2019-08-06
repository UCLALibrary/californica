# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaCsvParser do
  subject(:parser)    { described_class.new(file: file, import_file_path: import_file_path) }
  let(:file)          { File.open(csv_path) }
  let(:csv_path)      { 'spec/fixtures/example.csv' }
  let(:import_file_path) { fixture_path }
  let(:info_stream)   { [] }
  let(:error_stream)  { [] }

  after do
    ENV['SKIP'] = '0'
  end

  describe 'use in an importer', :clean do
    include_context 'with workflow'

    it 'has an import_file_path' do
      expect(parser.import_file_path).to eq fixture_path
    end

    let(:importer) do
      Darlingtonia::Importer.new(parser: parser, record_importer: ActorRecordImporter.new, info_stream: info_stream, error_stream: error_stream)
    end

    it 'imports records' do
      expect { importer.import }.to change { Work.count }.by 1
    end

    it 'skips records if ENV[\'SKIP\'] is set' do
      ENV['SKIP'] = '1'
      expect { importer.import }.to change { Work.count }.by 0
    end
  end

  describe '.for' do
    it 'builds an instance' do
      expect(described_class.for(file: file)).to be_a described_class
    end
  end

  describe '#records' do
    it 'lists records' do
      expect(parser.records.count).to eq 1
    end

    it 'can build attributes' do
      expect { parser.records.map(&:attributes) }.not_to raise_error
    end
  end

  describe '#headers' do
    let(:expected_headers) do
      ['Object Type',
       'Project Name',
       'Parent ARK',
       'Item ARK',
       'Subject',
       'Type.typeOfResource',
       'Rights.copyrightStatus',
       'Type.genre',
       'Name.subject',
       'Coverage.geographic',
       'Relation.isPartOf',
       'Publisher.publisherName',
       'Rights.countryCreation',
       'Rights.rightsHolderContact',
       'Name.architect',
       'Name.photographer',
       'Name.repository',
       'Date.normalized',
       'AltIdentifier.local',
       'Title',
       'Date.creation',
       'Format.extent',
       'Format.medium',
       'Format.dimensions',
       'Description.note',
       'Description.fundingNote',
       'Description.longitude',
       'Description.latitude',
       'Description.caption',
       'File Name',
       'AltTitle.other',
       'AltTitle.translated',
       'Place of origin',
       'AltTitle.uniform',
       'Support',
       'Author',
       'Summary',
       'Binding note']
    end

    it 'knows the headers for this CSV file' do
      expect(parser.headers).to eq expected_headers
    end

    context 'headers that are wrapped in quotes' do
      let(:csv_path) { File.join(fixture_path, 'quoted_headers.csv') }
      let(:expected_headers) { ['Item ARK', 'Title'] }

      it 'knows the headers for this CSV file' do
        expect(parser.headers).to eq expected_headers
      end
    end
  end
end
