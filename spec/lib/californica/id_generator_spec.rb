# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::IdGenerator, :clean do
  let(:ark) { 'ark:/13030/t8dn9c0x' }
  let(:extended_ark) { 'ark:/13030/t8dn9c0x/001' }
  let(:old_school) { '13030/t8dn9c0x' }
  let(:wonky_ark) { 'ark:13030/t8dn9c0x' }
  let(:spacey_ark) { ' ark:13030 / t8dn9c0x ' }
  let(:non_ark) { 'this is not an ark' }

  it 'makes a blacklight id from an ark' do
    id = Californica::IdGenerator.blacklight_id_from_ark(ark)
    expect(id).to eq '13030-t8dn9c0x'
  end

  it 'makes a fedora id from an ark' do
    id = Californica::IdGenerator.id_from_ark(ark)
    expect(id).to eq 'x0c9nd8t-03031'
  end

  it 'makes an id from arks without prefixes' do
    id = Californica::IdGenerator.id_from_ark(old_school)
    expect(id).to eq 'x0c9nd8t-03031'
  end

  it 'has relaxed rules about prefixes' do
    id = Californica::IdGenerator.id_from_ark(wonky_ark)
    expect(id).to eq 'x0c9nd8t-03031'
  end

  it 'removes whitespace from ids' do
    id = Californica::IdGenerator.id_from_ark(spacey_ark)
    expect(id).to eq 'x0c9nd8t-03031'
  end

  it 'allows arks with extensions' do
    id = Californica::IdGenerator.id_from_ark(extended_ark)
    expect(id).to eq '100-x0c9nd8t-03031'
  end

  it 'raises an error for arks that do not have a shoulder & blade' do
    expect { Californica::IdGenerator.id_from_ark(non_ark) }.to raise_error(ArgumentError, /ARK/)
  end
end
