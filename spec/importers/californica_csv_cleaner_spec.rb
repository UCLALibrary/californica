# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaCsvCleaner do
  subject(:cleaner) { described_class.new(file: file) }
  let(:file)        { File.open(csv_path) }
  let(:csv_path)    { 'spec/fixtures/example.csv' }
  let(:work)        { FactoryBot.create(:work, identifier: ["21198/zz0002nq4w"]) }
  let(:other_work)  { FactoryBot.create(:work, identifier: ["21198/zz0002nq4zzz"]) }

  describe 'when we need to reingest', :clean do
    before do
      work
      other_work
    end
    it 'removes all objects matching the unique id in a CSV file' do
      expect(Work.count).to eq 2
      cleaner.clean
      expect(Work.count).to eq 1
    end
  end
end
