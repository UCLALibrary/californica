# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ActorRecordImporter, :clean do
  subject(:importer) do
    described_class.new(error_stream: error_stream, info_stream: info_stream)
  end

  let(:record)        { Darlingtonia::InputRecord.from(metadata: metadata, mapper: CalifornicaMapper.new) }
  let(:error_stream)  { [] }
  let(:info_stream)   { [] }
  let(:metadata) do
    {
      'Title' => 'Comet in Moominland',
      'language' => 'English',
      'visibility' => 'open',
      'Item Ark' => 'ark:/abc/123'
    }
  end

  describe '#import' do
    include_context 'with workflow'

    it 'creates a work for record' do
      expect { importer.import(record: record) }
        .to change { Work.count }
        .by 1
    end

    it 'writes to the info_stream before and after create' do
      importer.import(record: record)
      expect(importer.info_stream.first).to match(/event: record_import_started/)
      expect(importer.info_stream.last).to match(/event: record_created/)
    end

    context 'with masterImageName' do
      let(:metadata) do
        {
          'Title' => 'Comet in Moominland',
          'masterImageName' => "clusc_1_1_00010432a.tif",
          'Item Ark' => "ark:/abc/1234"
        }
      end

      it 'attaches a file' do
        ENV['IMPORT_PATH'] = fixture_path
        expect { importer.import(record: record) }
          .to have_enqueued_job(IngestLocalFileJob)
      end
    end

    context 'with an invalid input record' do
      let(:metadata) do
        {
          'visibility' => 'open',
          'Item Ark' => 'ark:/abc/123'
        }
      end

      it 'logs an error' do
        expect { importer.import(record: record) }
          .to change { error_stream.first }
          .to match(/^event: validation_failed/)
      end
    end
  end
end
