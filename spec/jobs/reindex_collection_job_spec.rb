# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ReindexCollectionJob, type: :job do
  let(:collection_reindex) { FactoryBot.build(:csv_collection_reindex, ark: collection.ark, id: 9875) }
  let(:collection) { FactoryBot.build_stubbed(:collection) }

  before do
    allow(collection).to receive(:save)
    allow(CsvCollectionReindex).to receive(:find).with(collection_reindex.id).and_return(collection_reindex)
    allow(Collection).to receive(:find_by_ark).with(collection.ark).and_return(collection)
  end

  it 'sets recalculate_size=true' do
    collection.recalculate_size = false
    described_class.perform_now(collection_reindex.id)
    expect(collection.recalculate_size).to be true
  end

  it 'calls save to trigger a reindex' do
    described_class.perform_now(collection_reindex.id)
    expect(collection).to have_received(:save)
  end
end
