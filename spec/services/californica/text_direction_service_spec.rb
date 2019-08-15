# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::TextDirectionService do
  describe '.label' do
    let(:id) { 'http://iiif.io/api/presentation/2#leftToRightDirection' }
    let(:label) { 'left-to-right' }

    it 'finds the label of a known property' do
      expect(described_class.label(id)).to eq label
    end

    it 'raises an error for an unknown property' do
      expect { described_class.label('NOT A REAL TERM') }.to raise_error described_class::LookupError
    end
  end
end
