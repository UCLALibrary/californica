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

  describe 'sort_title' do
    let(:attributes) do
      {
        ark: 'ark:/123/456',
        recalculate_size: true,
        title: ['Primary title']
      }
    end

    it 'indexs the only value' do
      expect(solr_document['title_alpha_numeric_ssort']).to eq 'Primary title'
    end
  end

  describe '#thumbnail_url' do
    let(:attributes) do
      {
        ark: 'ark:/123/456',
        access_copy: access_copy,
        recalculate_size: true,
        thumbnail_link: thumbnail_link
      }
    end
    let(:access_copy) { nil }
    let(:thumbnail_link) { nil }

    context 'when thumbnail_link is a iiif resource' do
      let(:thumbnail_link) { 'https://fake.url/iiif/2/id' }

      it 'adds iiif parameters' do
        expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg'
      end

      context 'when it already includes iiif parameters' do
        let(:thumbnail_link) { 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg' }

        it 'does not add them again' do
          expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg'
        end
      end

      context 'when it doesn\'t match the expected format' do
        let(:thumbnail_link) { 'https://fake.url/iiif/2/id/full/!200,200/' }

        it 'returns nil' do
          expect(solr_document['thumbnail_url_ss']).to eq nil
        end
      end
    end

    context 'when thumbnail_link is an image url' do
      let(:thumbnail_link) { 'https://fake.url/id.svg' }

      it 'is indexed as is' do
        expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/id.svg'
      end
    end

    context 'when thumbnail_link is empty' do
      context 'when a iiif resource can be derived from an access copy' do
        let(:access_copy) { 'https://fake.url/iiif/2/id' }

        it 'adds iiif parameters' do
          expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg'
        end
      end

      context 'when access_copy is not a iiif resource' do
        let(:access_copy) { 'https://fake.url/media_stream/id' }

        it 'returns nil' do
          expect(solr_document['thumbnail_url_ss']).to be_nil
        end
      end

      context 'when access_copy is nil' do
        it 'returns nil' do
          expect(solr_document['thumbnail_url_ss']).to be_nil
        end
      end
    end
  end

  describe '#thumbnail_from_access_copy' do
    let(:expected_url) { 'http://fake.server/iiif/2/id' }

    context 'when the thumnail is coming from the collection' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          access_copy: expected_url,
          recalculate_size: true
        }
      end

      it 'uses that image' do
        expect(indexer.thumbnail_from_access_copy).to eq expected_url
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
        work = Work.new(ark: 'ark:/abc/xyz', access_copy: expected_url)
        allow(collection).to receive(:members).and_return([work])
        expect(indexer.thumbnail_from_access_copy).to eq expected_url
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
        child_work = ChildWork.new(ark: 'ark:/abc/xyz', access_copy: expected_url)
        allow(collection).to receive(:members).and_return([work])
        allow(work).to receive(:members).and_return([child_work])
        expect(indexer.thumbnail_from_access_copy).to eq expected_url
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
        expect(indexer.thumbnail_from_access_copy).to be_nil
      end
    end
  end
end
