# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaCsvCleaner, :clean do
  subject(:cleaner) { described_class.new(file: file) }
  let(:file)        { File.open(csv_path) }
  let(:csv_path)    { 'spec/fixtures/example.csv' }
  let(:record1)     { Darlingtonia::InputRecord.from(metadata: metadata1, mapper: CalifornicaMapper.new) }
  let(:record2)     { Darlingtonia::InputRecord.from(metadata: metadata2, mapper: CalifornicaMapper.new) }
  let(:metadata1) do
    {
      'Title' => 'Comet in Moominland',
      'language' => 'English',
      'visibility' => 'open',
      'Item Ark' => 'ark:/21198/zz0002nq4w'
    }
  end
  let(:metadata2) do
    {
      'Title' => 'World Tales',
      'language' => 'English',
      'visibility' => 'open',
      'Item Ark' => 'ark:/21198/zz0002nq4x'
    }
  end

  describe 'when we need to reingest', :clean do
    before do
      ActorRecordImporter.new.import(record: record1)
      ActorRecordImporter.new.import(record: record2)
    end
    it 'eradicates all objects matching the unique id in a CSV file' do
      expect(Work.count).to eq 2
      cleaner.clean
      expect(Work.count).to eq 1
      ActorRecordImporter.new.import(record: record1)
      expect(Work.count).to eq 2
    end
  end
end
