# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateManifestJob, :clean do
  let(:work) { FactoryBot.build_stubbed(:work) }
  let(:service) { Californica::ManifestBuilderService.new(curation_concern: work) }

  before do
    allow(Californica::ManifestBuilderService).to receive(:new).with(curation_concern: work).and_return(service)
    allow(Work).to receive(:find_by_ark).with(work.ark).and_return(work)
  end

  it 'calls the ManifestBuilderService' do
    allow(service).to receive(:persist)
    CreateManifestJob.perform_now(work.ark)
    expect(service).to have_received(:persist)
  end
end
