# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Ark do
  describe '::ensure_prefix' do
    subject(:ark) { described_class.ensure_prefix(input_string) }

    context 'an ark without a prefix' do
      let(:input_string) { '123/456' }

      it 'adds the prefix' do
        expect(ark).to eq 'ark:/123/456'
      end
    end

    context 'an ark that already has a prefix' do
      let(:input_string) { 'ark:/123/456' }

      it 'doesn\'t duplicate the prefix' do
        expect(ark).to eq 'ark:/123/456'
      end
    end

    context 'a blank string' do
      let(:input_string) { '' }

      it 'returns nil' do
        expect(ark).to eq nil
      end
    end
  end
end
