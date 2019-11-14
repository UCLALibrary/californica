# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::OrderChildWorksService do
  let(:order_children_object) { FactoryBot.build(:csv_import_order_child, ark: work.ark) }
  let(:page1) { FactoryBot.build(:child_work) }
  let(:page2) { FactoryBot.build(:child_work) }
  let(:page3) { FactoryBot.build(:child_work) }
  let(:work) { FactoryBot.build(:work) }

  before do
    allow(Work).to receive(:find_by_ark).with(work.ark).and_return(work)
    allow(ChildWork).to receive(:find_by_ark) do |ark|
      {
        page1.ark => page1,
        page2.ark => page2,
        page3.ark => page3
      }[ark]
    end
    allow(work).to receive(:save)
    PageOrder.create(parent: work.ark, child: page3.ark, sequence: 3)
    PageOrder.create(parent: work.ark, child: page1.ark, sequence: 1)
    PageOrder.create(parent: work.ark, child: page2.ark, sequence: 2)
  end

  it 'puts the ChildWorks in the right order' do
    described_class.new(order_children_object).order
    expect(work.ordered_members.to_a).to eq [page1, page2, page3]
  end

  it 'saves the work' do
    described_class.new(order_children_object).order
    expect(work).to have_received(:save)
  end
end
