# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Manifest, type: :model do
  let(:manifest) { described_class.new }
  let(:json) { '{ something: \'somewhere\'}' }
  describe 'storing some json' do
    it 'has a text field that can be used for storing the manifest' do
      manifest.json = json
      manifest.save
      expect(manifest.json).to eq(json)
    end
  end
end
