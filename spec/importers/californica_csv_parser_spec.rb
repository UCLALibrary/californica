# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaCsvParser do
  subject(:parser) { described_class.new(file: file) }
  let(:file)       { File.open(csv_path) }
  let(:csv_path)   { 'spec/fixtures/example.csv' }

  describe '.for' do
    it 'builds an instance' do
      expect(described_class.for(file: file)).to be_a described_class
    end
  end

  describe '#records' do
    it 'lists records' do
      expect(parser.records.count).to eq 1
    end
  end

  describe '#validate' do
    it 'is valid' do
      expect(parser.validate).to be_truthy
    end
  end
end
