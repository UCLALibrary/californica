# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReindexService do
  let(:reindex_service) { described_class.new(solr: alternate_solr_uri) }

  let!(:original_solr_uri) { ActiveFedora::SolrService.instance.conn.uri }
  let(:alternate_solr_uri) { 'http://example.com:8985/solr/test/' }
  let(:final_solr_uri) { ActiveFedora::SolrService.instance.conn.uri }

  it 'is a class that can be initialized' do
    expect(reindex_service).not_to eq(nil)
  end

  describe '#reindex' do
    context 'when reindexing succeeds' do
      before do
        allow(ActiveFedora::Base).to receive(:reindex_everything).and_return(true)
      end

      it 'reindex method returns true' do
        expect(reindex_service.reindex).to eq(true)
      end

      it 'resets the solr connection back to the original' do
        reindex_service.reindex
        expect(final_solr_uri.to_s.match?(/example.com/)).to eq false
        expect(final_solr_uri).to eq original_solr_uri
      end
    end

    context 'when reindexing fails' do
      before do
        allow(ActiveFedora::Base).to receive(:reindex_everything).and_return(false)
      end

      it 'reindex method returns false' do
        expect(reindex_service.reindex).to eq(false)
      end

      it 'resets the solr connection back to the original' do
        reindex_service.reindex
        expect(final_solr_uri.to_s.match?(/example.com/)).to eq false
        expect(final_solr_uri).to eq original_solr_uri
      end
    end
  end
end
