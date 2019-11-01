# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ReindexItemJob, type: :job do
  let(:item) { FactoryBot.build_stubbed(:collection) }

  before do
    Redis.current.flushall
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
    expect do
      described_class.perform_now(item.ark) # to reset Redis 'in_queue' lock
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
    let(:parent) { FactoryBot.build(:collection) }

    before do
      allow(Work).to receive(:find_by_ark).with(item.ark).and_return(item)
      allow(item).to receive(:member_of).and_return([parent])
    end

    it 'calls save to trigger a reindex' do
      described_class.perform_now(item.ark)
      expect(item).to have_received(:save)
    end

    it 'enqueues a CreateManifestJob' do
      expect do
        described_class.perform_now(item.ark)
      end.to have_enqueued_job(CreateManifestJob).with(item.ark, csv_import_id: nil)
    end

    it 'enqueues ReindexItemJob for parent' do
      expect do
        described_class.perform_now(item.ark)
      end.to have_enqueued_job(ReindexItemJob).with(parent.ark, csv_import_id: nil)
    end

    context 'when the Work has children' do
      let(:child1) { FactoryBot.build(:child_work) }
      let(:child2) { FactoryBot.build(:child_work) }
      let(:child3) { FactoryBot.build(:child_work) }
      let(:csv_import) { FactoryBot.build(:csv_import, id: csv_import_id) }
      let(:csv_import_id) { 3789 }
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
        allow(CsvImport).to receive(:find).with(csv_import_id).and_return(csv_import)
      end

      it 'applies the page order' do
        described_class.perform_now(item.ark, csv_import_id: csv_import_id)
        expect(item.ordered_member_ids).to eq [child1.id, child2.id, child3.id]
      end
    end
  end

  context 'when the item is a ChildWork' do
    let(:item) { FactoryBot.build(:child_work) }
    let(:parent) { FactoryBot.build(:work) }

    before do
      allow(ChildWork).to receive(:find_by_ark).with(item.ark).and_return(item)
      allow(item).to receive(:member_of).and_return([parent])
    end

    it 'calls save to trigger a reindex' do
      described_class.perform_now(item.ark)
      expect(item).to have_received(:save)
    end

    it 'enqueues a CreateManifestJob' do
      expect do
        described_class.perform_now(item.ark)
      end.to have_enqueued_job(CreateManifestJob).with(item.ark, csv_import_id: nil)
    end

    it 'enqueues ReindexItemJob for parent' do
      expect do
        described_class.perform_now(item.ark)
      end.to have_enqueued_job(ReindexItemJob).with(parent.ark, csv_import_id: nil)
    end
  end

  context 'when it gets a CsvImportTask object' do
    let(:csv_import_id) { 9856 }
    let(:csv_import_task) { FactoryBot.build(:csv_import_task, job_duration: nil) }
    let(:csv_import) { FactoryBot.build(:csv_import, id: csv_import_id) }
    let(:item) { FactoryBot.build(:work) }

    before do
      allow(CsvImport).to receive(:find).with(csv_import_id).and_return(csv_import)
      allow_any_instance_of(described_class).to receive(:csv_import_task).and_return(csv_import_task)
      allow(Work).to receive(:find_by_ark).with(item.ark).and_return(item)
    end

    it 'logs the duration to that object' do
      csv_import_task
      described_class.perform_now(item.ark, csv_import_id: csv_import_id)
      expect(csv_import_task.job_duration).not_to be_nil
    end
  end

  describe '#log_end' do
    let(:csv_import) { FactoryBot.build(:csv_import, id: 3962) }
    let(:service) { Californica::CsvImportService.new(csv_import) }

    before do
      allow(Collection).to receive(:find_by_ark).with(item.ark).and_return(item)
      allow(CsvImport).to receive(:find).with(csv_import.id).and_return(csv_import)
      allow(Californica::CsvImportService).to receive(:new).and_return(service)
      allow(service).to receive(:update_status)
    end

    context 'when there is no csv_import_id argument' do
      it 'does not call Californica::CsvImportService#update_status' do
        described_class.perform_now(item.ark)
        expect(service).not_to have_received(:update_status)
      end
    end

    context 'when there is a csv_import_id argument' do
      it 'calls Californica::CsvImportService#update_status' do
        described_class.perform_now(item.ark, csv_import_id: csv_import.id)
        expect(service).to have_received(:update_status)
      end
    end
  end
end
