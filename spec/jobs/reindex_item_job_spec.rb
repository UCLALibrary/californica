# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ReindexItemJob, type: :job do
  let(:item) { FactoryBot.build_stubbed(:collection) }

  before do
    allow(item).to receive(:save)
  end
  
  it 'sets recalculate_size=true' do
    allow(Collection).to receive(:find_by_ark).with(item.ark).and_return(item)
    described_class.perform_now(item.ark)
    expect(item.recalculate_size).to be true
  end
  
  it 'calls save to trigger a reindex' do
    allow(Collection).to receive(:find_by_ark).with(item.ark).and_return(item)
    described_class.perform_now(item.ark)
    expect(item).to have_received(:save)
  end

  it 'gets deduplicated' do
    expect do
      described_class.perform_later(item.ark)
      described_class.perform_later(item.ark)
    end.to have_enqueued_job(described_class).exactly(:once)
  end
  
  context 'when the item is a Work' do
    let(:item) { FactoryBot.build(:work) }

    it 'calls save to trigger a reindex' do
      allow(Work).to receive(:find_by_ark).with(item.ark).and_return(item)
      described_class.perform_now(item.ark)
      expect(item).to have_received(:save)
    end
  end
  
  context 'when the item is a ChildWork' do
    let(:item) { FactoryBot.build(:work) }

    it 'calls save to trigger a reindex' do
      allow(ChildWork).to receive(:find_by_ark).with(item.ark).and_return(item)
      described_class.perform_now(item.ark)
      expect(item).to have_received(:save)
    end
  end

  context 'when it gets a CsvImport object' do
    let(:csv_import) { FactoryBot.build(:csv_import) }

    it 'logs the time to that object'
  end
end
