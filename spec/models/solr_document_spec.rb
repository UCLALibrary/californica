# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  let(:solr_document) { described_class.new(fields) }

  let(:fields) do
    { id: '456xyz',
      caption_tesim: [''],
      dimensions_tesim: [''],
      extent_tesim: [''],
      funding_note_tesim: [''],
      genre_tesim: [''],
      latitude_tesim: [''],
      longitude_tesim: [''],
      medium_tesim: [''],
      named_subject_tesim: [''],
      normalized_date_tesim: [''],
      repository_tesim: [''],
      rights_country_tesim: [''],
      rights_holder_tesim: [''] }
  end

  it 'has extent' do
    expect(solr_document.extent).to eq([''])
  end

  it 'has caption' do
    expect(solr_document.caption).to eq([''])
  end
  it 'has dimensions' do
    expect(solr_document.dimensions).to eq([''])
  end
  it 'has funding_note' do
    expect(solr_document.funding_note).to eq([''])
  end
  it 'has genre' do
    expect(solr_document.genre).to eq([''])
  end

  it 'has latitude' do
    expect(solr_document.latitude).to eq([''])
  end

  it 'has longitude' do
    expect(solr_document.longitude).to eq([''])
  end
  it 'has medium' do
    expect(solr_document.medium).to eq([''])
  end

  it 'has named_subject' do
    expect(solr_document.named_subject).to eq([''])
  end

  it 'has normalized_date' do
    expect(solr_document.normalized_date).to eq([''])
  end

  it 'has repository' do
    expect(solr_document.repository).to eq([''])
  end

  it 'has rights_country' do
    expect(solr_document.rights_country).to eq([''])
  end

  it 'has rights_holder' do
    expect(solr_document.rights_holder).to eq([''])
  end

  describe '#iiif_manifest_url' do
    context 'when a url is stored and feature enabled' do
      let(:fields) do
        { iiif_manifest_url_ssi: 'https://manifest.store.url/abc123/manifest' }
      end

      it 'uses that url' do
        allow(Flipflop).to receive(:use_manifest_store?).and_return(true)
        expect(solr_document.iiif_manifest_url).to eq 'https://manifest.store.url/abc123/manifest'
      end
    end

    context 'when a url is stored but feature is disabled' do
      let(:fields) do
        { id: '456xyz',
          iiif_manifest_url_ssi: 'https://manifest.store.url/abc123/manifest' }
      end

      it 'builds a local url' do
        allow(Flipflop).to receive(:use_manifest_store?).and_return(false)
        expect(solr_document.iiif_manifest_url).to eq '/concern/works/456xyz/manifest'
      end
    end

    context 'when nothing is stored' do
      it 'builds a local url' do
        expect(solr_document.iiif_manifest_url).to eq '/concern/works/456xyz/manifest'
      end
    end
  end

  describe 'visibility' do
    subject(:visibility) { solr_document.visibility }
    let(:solr_document) { described_class.new(work.to_solr) }

    let(:discovery_access) { Work::VISIBILITY_TEXT_VALUE_SINAI }
    let(:public_access) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    let(:embargo_access) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO }
    let(:lease_access) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_LEASE }

    context 'a work with an embargo that has current visibility set to "sinai"' do
      let(:work) do
        w = Work.new(ark: 'ark:/abc/1234')
        w.apply_embargo(Date.tomorrow.to_s, discovery_access, public_access)
        w
      end

      it 'returns the correct visibility for an embargo' do
        expect(visibility).to eq embargo_access
      end
    end

    context 'a work with a lease that has current visibility set to "sinai"' do
      let(:work) do
        w = Work.new(ark: 'ark:/abc/1234')
        w.apply_lease(Date.tomorrow.to_s, discovery_access, public_access)
        w
      end

      it 'returns the correct visibility for a lease' do
        expect(visibility).to eq lease_access
      end
    end
  end
end
