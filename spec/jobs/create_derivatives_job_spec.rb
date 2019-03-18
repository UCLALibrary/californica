# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateDerivativesJob do
  # around do |example|
  #   ffmpeg_enabled = Hyrax.config.enable_ffmpeg
  #   Hyrax.config.enable_ffmpeg = true
  #   example.run
  #   Hyrax.config.enable_ffmpeg = ffmpeg_enabled
  # end

  let(:collection_with_thumbnail) { FactoryBot.create(:collection_lw, thumbnail_id: old_id) }
  let(:collection_without_thumbnail) { FactoryBot.create(:collection_lw) }
  let(:new_work) { Work.create(title: 'test work', member_of_collections: [collection_with_thumbnail, collection_without_thumbnail])}

  let(:old_id)       { 'lkjhgasr' }
  let(:old_file_set) { FileSet.new }

  let(:old_file) do
    Hydra::PCDM::File.new.tap do |f|
      f.content = 'foo'
      f.original_name = 'picture.png'
      f.save!
    end
  end
  
  let(:new_id)       { 'uinepiha' }
  let(:new_file_set) { FileSet.new }

  let(:new_file) do
    Hydra::PCDM::File.new.tap do |f|
      f.content = 'new_foo'
      f.original_name = 'new_picture.png'
      f.save!
    end
  end


  before do
    allow(FileSet).to receive(:find).with(old_id).and_return(old_file_set)
    allow(FileSet).to receive(:find).with(new_id).and_return(new_file_set)
    allow(old_file_set).to receive(:id).and_return(old_id)
    allow(new_file_set).to receive(:id).and_return(new_id)
    # allow(file_set).to receive(:mime_type).and_return('image/png')
  end

  context "with a file name" do
    it 'sets collection thumbnail only if empty' do
      # expect(Hydra::Derivatives::ImageDerivatives).to receive(:create)
      expect(new_work.thumbnail_id).to_equal new_id
      expect(new_file_set).to receive(:reload)
      expect(new_file_set).to receive(:update_index)

      # expect(collection_with_thumbnail).thumbnail_id.to_equal 'laghujd'
      # expect(collection_without_thumbnail).thumbnail_id.to_equal 'lkjhgasr'
      # described_class.perform_now(file_set, file.id)
    end
  end
end
