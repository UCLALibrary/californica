# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateManifestJob, :clean do
  let(:work) { FactoryBot.build_stubbed(:work) }
  let(:service) { Californica::ManifestBuilderService.new(curation_concern: work) }

  before do
    Redis.current.flushall
    allow(Californica::ManifestBuilderService).to receive(:new).with(curation_concern: work).and_return(service)
    allow(Work).to receive(:find_by_ark).with(work.ark).and_return(work)
  end

  it 'calls the ManifestBuilderService' do
    allow(service).to receive(:persist)
    CreateManifestJob.perform_now(work.ark)
    expect(service).to have_received(:persist)
  end

  it 'gets deduplicated' do
    expect do
      described_class.perform_later(work.ark)
      described_class.perform_later(work.ark)
    end.to have_enqueued_job(described_class).exactly(:once)
  end

  context 'when it gets a CsvImportTask object' do
    let(:csv_import_id) { 9856 }
    let(:csv_import_task) do
      csv_import_task = FactoryBot.build(:csv_import_task, job_duration: nil)
      allow_any_instance_of(described_class).to receive(:csv_import_task).and_return(csv_import_task)
      csv_import_task
    end

    before { allow_any_instance_of(Californica::ManifestBuilderService).to receive(:persist) }

    it 'logs the duration to that object' do
      csv_import_task
      described_class.perform_now(work.ark, csv_import_id: csv_import_id)
      expect(csv_import_task.job_duration).not_to be_nil
    end
  end
end
