# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ::RecordImporter, :clean do
  subject(:importer) { described_class.new(error_stream: [], info_stream: [], attributes: { deduplication_field: 'ark' }) }

  context 'with counts from different importers' do
    before do
      # Stub out some fake results
      allow_any_instance_of(CollectionRecordImporter).to receive(:success_count).and_return(3)
      allow_any_instance_of(ActorRecordImporter).to receive(:success_count).and_return(1)
      allow_any_instance_of(CollectionRecordImporter).to receive(:failure_count).and_return(4)
      allow_any_instance_of(ActorRecordImporter).to receive(:failure_count).and_return(6)
    end

    it 'sums together the success counts' do
      expect(importer.success_count).to eq 4
    end

    it 'sums together the failure counts' do
      expect(importer.failure_count).to eq 10
    end
  end
end
