# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::IdGenerator, :clean do
  let(:ark) { 'ark:/13030/t8dn9c0x' }
  it 'makes a fedora id from an ark' do
    id = Californica::IdGenerator.id_from_ark(ark)
    expect(id).to eq 't8dn9c0x-13030'
  end
end
