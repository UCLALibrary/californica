# frozen_string_literal: true
require 'rails_helper'

RSpec.describe WorkIndexer do
  let(:solr_document) { indexer.generate_solr_document }
  let(:work) { Work.new(attributes) }
  let(:indexer) { described_class.new(work) }

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
