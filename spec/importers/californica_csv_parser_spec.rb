# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaCsvParser do
  subject(:parser)    { described_class.new(file: file) }
  let(:file)          { File.open(csv_path) }
  let(:csv_path)      { 'spec/fixtures/example.csv' }
  let(:info_stream)   { [] }
  let(:error_stream)  { [] }

  after do
    ENV['SKIP'] = '0'
  end

  describe 'use in an importer', :clean do
    include_context 'with workflow'

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
      ['Project Name', 'Parent ARK', 'Item Ark',
       'Subject', 'Type.typeOfResource',
       'Rights.copyrightStatus', 'Type.genre',
       'Name.subject', 'Coverage.geographic',
       'Relation.isPartOf', 'Publisher.publisherName',
       'Rights.countryCreation',
       'Rights.rightsHolderContact',
       'Name.photographer', 'Name.repository',
       'Date.normalized',
       'AltIdentifier.local', 'Title',
       'Date.creation', 'Format.extent',
       'Format.medium', 'Format.dimensions',
       'Description.note', 'Description.fundingNote',
       'Description.longitude',
       'Description.latitude', 'Description.caption',
       'masterImageName']
    end

    it 'knows the headers for this CSV file' do
      expect(parser.headers).to eq expected_headers
    end

    context 'headers that are wrapped in quotes' do
      let(:csv_path) { File.join(fixture_path, 'quoted_headers.csv') }
      let(:expected_headers) { ['Item Ark', 'Title'] }

      it 'knows the headers for this CSV file' do
        expect(parser.headers).to eq expected_headers
      end
    end
  end

  describe '#validate' do
    it 'is valid' do
      expect(parser.validate).to be_truthy
    end

    context 'with an invalid csv' do
      let(:file) { File.open('spec/fixtures/mods_example.xml') }

      it 'is invalid' do
        expect(parser.validate).to be_falsey
      end
    end
  end

  describe 'validators' do
    subject(:parser) { described_class.new(file: file, error_stream: error_stream) }

    let(:error_stream) { CalifornicaLogStream.new }

    it 'use the same error stream as the parser' do
      expect(parser.validators.map(&:error_stream)).to eq [error_stream, error_stream, error_stream, error_stream]
    end
  end
end
