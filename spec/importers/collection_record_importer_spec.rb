# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CollectionRecordImporter, :clean do
  subject(:importer) { described_class.new(error_stream: [], info_stream: [], attributes: importer_attrs) }
  let(:importer_attrs) { { deduplication_field: 'ark' } }
  let(:record) { Darlingtonia::InputRecord.from(metadata: metadata, mapper: CalifornicaMapper.new) }

  let(:metadata) do
    { 'Title' => 'Collection ABC 123',
      'Item Ark' => 'ark:/abc/123',
      'Description.note' => 'desc 1|~|desc 2',
      'Rights.servicesContact' => 'UCLA Charles E. Young Research Library Department of Special Collections',
      'Object Type' => 'Collection' }
  end

  describe '#import' do
    include_context 'with workflow'

    context 'when the collection doesn\'t exist yet' do
      let(:collection) { Collection.first }

      it 'creates the collection' do
        expect { importer.import(record: record) }
          .to change { Collection.count }.to(1)

        # Check metadata is correct
        expect(collection.title).to eq ['Collection ABC 123']
        expect(collection.ark).to eq 'ark:/abc/123'
        expect(collection.description).to contain_exactly('desc 1', 'desc 2')
        expect(collection.services_contact.first).to match(/Young Research Library/)

        # Check log messages
        expect(importer.info_stream.first).to match(/event: collection_import_started/)
        expect(importer.info_stream.last).to match(/event: collection_created/)

        # Check counters
        expect(importer.success_count).to eq 1
        expect(importer.failure_count).to eq 0
      end
    end

    context 'when the collection creation fails' do
      let(:metadata) do
        { 'Title' => nil, # Nil title is invalid
          'Item Ark' => 'ark:/abc/123',
          'Object Type' => 'Collection' }
      end

      it 'logs the failure' do
        importer.import(record: record)

        # Check log messages
        expect(importer.info_stream.first).to match(/event: collection_import_started/)
        expect(importer.error_stream.last).to match(/event: validation_failed/)

        # Check counters
        expect(importer.success_count).to eq 0
        expect(importer.failure_count).to eq 1
      end
    end

    context 'when the collection already exists' do
      let(:collection) do
        coll = Collection.find_or_create_by_ark(metadata['Item Ark'])
        coll.description = ['old description']
        coll.genre = ['old genre']
        coll.save!
        coll
      end

      it 'updates the existing record' do
        expect(collection.description).to eq ['old description']

        expect { importer.import(record: record) }
          .to change { Collection.count }.by(0)
        collection.reload # Check persisted state

        # Check metadata is correct
        expect(collection.title).to eq ['Collection ABC 123']
        expect(collection.ark).to eq 'ark:/abc/123'
        expect(collection.description).to contain_exactly('desc 1', 'desc 2')
        expect(collection.genre).to eq []

        # Check log messages
        expect(importer.info_stream.first).to match(/event: collection_update_started/)
        expect(importer.info_stream.last).to match(/event: collection_updated/)

        # Check counters
        expect(importer.success_count).to eq 1
        expect(importer.failure_count).to eq 0
      end
    end

    context 'when the collection update fails' do
      let!(:collection) { Collection.find_or_create_by_ark(metadata['Item Ark']) }

      let(:metadata) do
        { 'Title' => nil, # Nil title is invalid
          'Item Ark' => 'ark:/abc/123',
          'Object Type' => 'Collection' }
      end

      it 'logs the failure' do
        importer.import(record: record)

        # Check log messages
        expect(importer.info_stream.first).to match(/event: collection_update_started/)
        expect(importer.error_stream.last).to match(/event: validation_failed/)

        # Check counters
        expect(importer.success_count).to eq 0
        expect(importer.failure_count).to eq 1
      end
    end
  end
end
