# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::IsValidImage do
  let(:corrupted_file) { Rails.root.join('spec', 'fixtures', 'images', 'corrupted', 'food.tif') }
  let(:good_file) { Rails.root.join('spec', 'fixtures', 'images', 'good', 'food.tif') }
  let(:is_valid_image_with_corrupted_file) { described_class.new(image: corrupted_file) }
  let(:is_valid_image) { described_class.new(image: good_file) }

  describe '#valid?' do
    it 'returns false if the image is currupted' do
      expect(is_valid_image_with_corrupted_file.valid?).to eq(false)
    end

    it 'returns true if the image is valid' do
      expect(is_valid_image.valid?).to eq(true)
    end
  end
end
