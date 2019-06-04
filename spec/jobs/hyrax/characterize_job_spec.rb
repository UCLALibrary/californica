# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::CharacterizeJob do
  context 'a row has a corrupt file', :clean, :inline_jobs do
    let(:corrupt_file) { File.join(fixture_path, 'images', 'corrupted', 'food.tif') }
    let(:file_set) { FactoryBot.create(:file_set) }
    let(:original_logger) { Rails.logger }
    let(:output) { StringIO.new }
    let(:work) { FactoryBot.create(:work) }
    let(:file_id) { file_set.files.first.id }
    let(:characterization_error) { output.string }

    before do
      original_logger
      Rails.logger = Logger.new(output)
      Hydra::Works::AddFileToFileSet.call(file_set, File.open(corrupt_file, 'rb'), :original_file)
      work.ordered_members << file_set
      work.save
      described_class.perform_now(file_set, file_id)
    end

    after do
      Rails.logger = original_logger
    end

    it 'reports corrupt files in the log' do
      expect(characterization_error).to match(/event: unexpected file characterization/)
      expect(characterization_error).to match(/ark: #{Work.last.ark}/)
      expect(characterization_error).to match(/work_id: #{Work.last.id}/)
      expect(characterization_error).to match(/food.tif/)
      # Different versions of FITS return different mime types
      expect(characterization_error).to match(/mime_type: image\/tiff/).or match(/mime_type: application\/octet-stream/)
    end
  end
end
