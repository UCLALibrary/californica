# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Manifest, type: :model do
  let(:manifest) { described_class.new }
  let(:json) { '{ something: \'somewhere\'}' }
  let(:cache_manifest_key) { '2019-something' }
  describe 'storing some json' do
    it 'has a text field that can be used for storing the manifest' do
      manifest.json = json
      manifest.save
      expect(manifest.json).to eq(json)
    end

    it 'has a string that can be used for storing a key for caching' do
      manifest.cache_manifest_key = cache_manifest_key
      manifest.save
      expect(manifest.cache_manifest_key).to eq(cache_manifest_key)
    end

    it 'can determine if a manifest exists based on the cache key' do
      manifest.cache_manifest_key = cache_manifest_key
      manifest.save
      expect(Manifest.exists?(cache_manifest_key: cache_manifest_key)).to eq true
    end

    it 'can find a record based on the cache key' do
      manifest.cache_manifest_key = cache_manifest_key
      manifest.save
      expect(Manifest.find_by(cache_manifest_key: cache_manifest_key)).to be_a Manifest
    end
  end
end
