# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReindexService do
  let(:reindex_service) { described_class.new(solr: ActiveFedora::SolrService.instance.options[:url]) }

  it 'is a class that can be initialized' do
    expect(reindex_service).not_to eq(nil)
  end

  it 'has a reindex method that succeeds' do
    expect(reindex_service.reindex).to eq(true)
  end
end
