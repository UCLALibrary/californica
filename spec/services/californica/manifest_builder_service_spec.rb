# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Californica::ManifestBuilderService do
  let(:parent_image_path) { 'parent/image.tif' }
  let(:child_image_path_1) { 'child/image_1.tif' }
  let(:child_image_path_2) { 'child/image_2.tif' }
  let(:child_work1) { FactoryBot.create(:child_work, master_file_path: child_image_path_1) }
  let(:child_work2) { FactoryBot.create(:child_work, master_file_path: child_image_path_2) }
  let(:work) do
    w = FactoryBot.create(:work, master_file_path: parent_image_path)
    w.ordered_members << child_work1
    w.ordered_members << child_work2
    w
  end
  let(:service) { described_class.new(curation_concern: work) }

  describe '#image_concerns' do
    it 'returns the set of works needed to create a manifest' do
      expect(service.image_concerns).to eq [work, child_work1, child_work2]
    end

    context 'When the parent work has no master_file_path' do
      let(:parent_image_path) { nil }

      it 'returns the set of child works' do
        expect(service.image_concerns).to eq [child_work1, child_work2]
      end
    end

    context 'When the parent work has no children' do
      let(:work) { FactoryBot.create(:work, master_file_path: parent_image_path) }

      it 'returns only the parent' do
        expect(service.image_concerns).to eq [work]
      end
    end

    context 'When the parent work has neither master_file_path nor children' do
      let(:work) { FactoryBot.create(:work, master_file_path: nil) }

      it 'returns nothing' do
        expect(service.image_concerns).to eq []
      end
    end

    context 'When the a child work has no master_file_path' do
      let(:child_image_path_1) { nil }

      it 'does not include the child' do
        expect(service.image_concerns).to eq [work, child_work2]
      end
    end
  end
end
