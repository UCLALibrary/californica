# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StartCsvImportJob, :clean, :inline_jobs do
  let(:csv_file) { File.join(fixture_path, 'csv_import', 'multipage_mss', 'mss_sample.csv') }
  let(:import_file_path) { File.join(fixture_path, 'images', 'ethiopian_mss').to_s }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest, import_file_path: import_file_path) }
  let(:manifest) { Rack::Test::UploadedFile.new(Rails.root.join(csv_file), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }

  context 'happy path for mss objects', :clean do
    it 'imports expected objects' do
      described_class.perform_now(csv_import.id)
      expect(Collection.count).to eq 1
      # For the moment, there are 4 works.
      # Next, we'll turn this into three pages, each attached to a work
      expect(Work.count).to eq 1
      expect(ChildWork.count).to eq 3
      collection = Collection.last
      # The work is attached to the Collection as expected
      expect(collection.child_works.count).to eq 1
      expect(collection.child_works.first.title.first).to eq "Ms. 50 Marbabeta Salomon, Ṣalota Susnyos"
      # The Pages are attached to the Work as expected
      work = Work.last
      expect(work.members.size).to eq 3
      # It makes a PageOrder object for each Page
      expect(PageOrder.count).to eq 3
      expect(work.ordered_member_ids).to eq ["rm6zp100zz-89112", "qj6zp100zz-89112", "7k6zp100zz-89112"]
    end
  end

  context 'the pages are defined before the work' do
    pending
  end
end
