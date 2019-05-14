# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PageOrder, type: :model do
  subject(:page_order) { described_class.new }

  it 'can be instantiated' do
    expect(page_order).to be_instance_of(described_class)
  end
end
