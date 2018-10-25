# frozen_string_literal: true
require 'rails_helper'

RSpec.describe WorkIndexer do
  let(:solr_document) { indexer.generate_solr_document }
  let(:work) { Work.new(attributes) }
  let(:indexer) { described_class.new(work) }

  describe 'rights statement' do
    context 'a work with a rights statement' do
      let(:attributes) { { rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'] } }

      it 'indexes a human-readable rights statement' do
        expect(solr_document['human_readable_rights_statement_tesim']).to eq ['copyrighted']
      end
    end

    # This should never happen in production data,
    # but if it does, handle it gracefully.
    context 'when there is no human-readable value' do
      let(:no_match) { "a rights statement that doesn't have a matching value in config/authorities/rights_statements.yml" }
      let(:attributes) { { rights_statement: [no_match, 'http://vocabs.library.ucla.edu/rights/copyrighted'] } }

      it 'just returns the original value' do
        expect(solr_document['human_readable_rights_statement_tesim']).to contain_exactly(no_match, 'copyrighted')
      end
    end
  end

  describe 'latitude and longitude' do
    context 'a work with latitude and longitude' do
      let(:attributes) do
        { latitude: ['45.0'],
          longitude: ['-93.0'] }
      end

      it 'indexes the coordinates in a single field' do
        expect(solr_document['geographic_coordinates_ssim']).to eq '45.0, -93.0'
      end
    end

    context 'a work that is missing latitude' do
      let(:attributes) { { longitude: ['-93.0'] } }

      it 'doesn\'t index the coordinates' do
        expect(solr_document['geographic_coordinates_ssim']).to eq nil
      end
    end

    context 'a work that is missing longitude' do
      let(:attributes) { { latitude: ['45.0'] } }

      it 'doesn\'t index the coordinates' do
        expect(solr_document['geographic_coordinates_ssim']).to eq nil
      end
    end
  end
end
