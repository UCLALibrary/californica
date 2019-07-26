# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ::CollectionIndexer do
  let(:solr_document) { indexer.generate_solr_document }
  let(:indexer) { described_class.new(collection) }
  let(:collection) { ::Collection.new(attributes) }

  describe 'indexing ARK and identifier fields' do
    let(:attributes) { { ark: 'ark:/123/456' } }

    it 'add the fields to the solr document' do
      expect(solr_document['ark_ssi']).to eq 'ark:/123/456'
    end

    it 'indexes a simplified id for ursus' do
      expect(solr_document['ursus_id_ssi']).to eq '123-456'
    end
  end

  describe '#thumbnail_url' do
    let(:expected_url) { "#{ENV['IIIF_SERVER_URL']}master%2Ffile%2Fpath.jpg/full/!200,200/0/default.jpg" }

    context 'when the thumnail is coming from the collection' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          master_file_path: 'master/file/path.jpg',
          recalculate_size: true
        }
      end

      it 'uses that image' do
        expect(solr_document['thumbnail_url_ss']).to eq expected_url
      end
    end

    context 'when the thumbnail is coming from the Work' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          recalculate_size: true
        }
      end

      it 'uses the thumbnail image from the Work' do
        work = Work.new(ark: 'ark:/abc/xyz', master_file_path: 'master/file/path.jpg')
        allow(collection).to receive(:members).and_return([work])
        expect(solr_document['thumbnail_url_ss']).to eq expected_url
      end
    end

    context 'when the thumbnail is coming from the ChildWork' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          recalculate_size: true
        }
      end

      it 'uses the thumbnail image from the ChildWork' do
        work = Work.new(ark: 'ark:/abc/xyz')
        child_work = ChildWork.new(ark: 'ark:/abc/xyz', master_file_path: 'master/file/path.jpg')
        allow(collection).to receive(:members).and_return([work])
        allow(work).to receive(:members).and_return([child_work])
        expect(solr_document['thumbnail_url_ss']).to eq expected_url
      end
    end

    context 'when neither the Work nor the ChildWork have thumnails' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          recalculate_size: true
        }
      end

      it 'returns nil' do
        expect(solr_document['thumbnail_url_ss']).to eq nil
      end
    end
  end
end
