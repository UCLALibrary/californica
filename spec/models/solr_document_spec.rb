# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  let(:solr_document) do
    described_class.new(extent_tesim: [''],
                        caption_tesim: [''],
                        dimensions_tesim: [''],
                        funding_note_tesim: [''],
                        genre_tesim: [''],
                        latitude_tesim: [''],
                        longitude_tesim: [''],
                        medium_tesim: [''],
                        named_subject_tesim: [''],
                        normalized_date_tesim: [''],
                        repository_tesim: [''],
                        rights_country_tesim: [''],
                        rights_holder_tesim: [''])
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
end
