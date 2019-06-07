# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Californica::ChildWorkService do
  let(:work) { FactoryBot.create(:work) }
  let(:work2) { FactoryBot.create(:work) }
  let(:cws) { described_class.new }
  before do
    work.ordered_members << work2
    work.save!
    work2.save!
  end

  describe '#child_works' do
    it 'returns an array of members that are Work or ChildWork' do
      expect(cws.child_works(member_ids_ssim: SolrDocument.find(work.id)[:member_ids_ssim])).to eq([work2.id])
    end
  end
end
