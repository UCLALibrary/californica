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
    allow(Collection).to receive(:find_by_ark).with(item.ark).and_return(item)
    described_class.perform_now(item.ark)
    expect do
      described_class.perform_later(item.ark)
      described_class.perform_later(item.ark)
    end.to have_enqueued_job(described_class).exactly(:once)
  end

  context 'when the item is a collection' do
    before { allow(Collection).to receive(:find_by_ark).with(item.ark).and_return(item) }

    it 'does not enqueue a CreateManifestJob' do
      expect do
        described_class.perform_now(item.ark)
      end.not_to have_enqueued_job(CreateManifestJob).with(item.ark)
    end
  end

  context 'when the item is a Work' do
    let(:item) { FactoryBot.build(:work) }
    before { allow(Work).to receive(:find_by_ark).with(item.ark).and_return(item) }

    it 'calls save to trigger a reindex' do
      described_class.perform_now(item.ark)
      expect(item).to have_received(:save)
    end

    it 'enqueues a CreateManifestJob' do
      expect do
        described_class.perform_now(item.ark)
      end.to have_enqueued_job(CreateManifestJob).with(item.ark)
    end

    context 'when the Work has children' do
      let(:child1) { FactoryBot.build(:child_work) }
      let(:child2) { FactoryBot.build(:child_work) }
      let(:child3) { FactoryBot.build(:child_work) }
      let(:page_order_objects) do
        [PageOrder.new(parent: item.ark, child: child2.ark, sequence: 2),
         PageOrder.new(parent: item.ark, child: child1.ark, sequence: 1),
         PageOrder.new(parent: item.ark, child: child3.ark, sequence: 3)]
      end

      before do
        allow(PageOrder).to receive(:where).with(parent: item.ark).and_return(page_order_objects)
        allow(ChildWork).to receive(:find_by_ark).with(child1.ark).and_return(child1)
        allow(ChildWork).to receive(:find_by_ark).with(child2.ark).and_return(child2)
        allow(ChildWork).to receive(:find_by_ark).with(child3.ark).and_return(child3)
        # allow(item).to receive(:save).and_call_original
      end

      it 'applies the page order' do
        described_class.perform_now(item.ark, csv_import_id: 123)
        expect(item.ordered_member_ids).to eq [child1.id, child2.id, child3.id]
      end
    end
  end

  context 'when the item is a ChildWork' do
    let(:item) { FactoryBot.build(:work) }
    before { allow(ChildWork).to receive(:find_by_ark).with(item.ark).and_return(item) }

    it 'calls save to trigger a reindex' do
      described_class.perform_now(item.ark)
      expect(item).to have_received(:save)
    end

    it 'enqueues a CreateManifestJob' do
      expect do
        described_class.perform_now(item.ark)
      end.to have_enqueued_job(CreateManifestJob).with(item.ark)
    end
  end

  context 'when it gets a CsvImport object' do
    let(:csv_import) { FactoryBot.build(:csv_import) }

    it 'logs the time to that object'
  end
end
