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

  context 'when it is called with a create_manifest_object_id' do
    let(:create_manifest_object) { FactoryBot.create(:csv_import_create_manifest, status: 'queued', ark: work.ark, error_messages: []) }

    it 'logs the start and end to the CsvImportCreateManifest' do
      allow(service).to receive(:persist)
      CreateManifestJob.perform_now(work.ark, create_manifest_object_id: create_manifest_object.id)
      create_manifest_object.reload
      expect(create_manifest_object.status).to eq 'complete'
    end

    it 'logs errors to the CsvImportCreateManifest' do
      allow(service).to receive(:persist).and_raise('test error')
      CreateManifestJob.perform_now(work.ark, create_manifest_object_id: create_manifest_object.id)
      create_manifest_object.reload
      expect(create_manifest_object.status).to eq 'error'
      expect(create_manifest_object.error_messages).to eq ['test error']
    end
  end
end
