# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Californica::ManifestBuilderService do
  let(:work) { FactoryBot.create(:work) }
  let(:work2) { FactoryBot.create(:work) }
  let(:work_with_file_sets) { FactoryBot.create(:work) }
  let(:service) { described_class.new(curation_concern: work) }
  let(:service_with_file_sets) { described_class.new(curation_concern: work_with_file_sets) }
  let(:file_set) { FactoryBot.create(:file_set) }

  describe '#sets' do
    it 'returns the set of works needed to create a manifest' do
      work.ordered_members << work2
      expect(service.sets.first.class).to eq Work
    end

    it 'returns the set of filsets needed to create a manifest' do
      work_with_file_sets.ordered_members << file_set
      expect(service_with_file_sets.sets.first.class).to eq FileSet
    end
  end
end
