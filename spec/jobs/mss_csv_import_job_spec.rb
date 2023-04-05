# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StartCsvImportJob, :clean, :inline_jobs do
  let(:import_file_path) { File.join(fixture_path, 'images', 'ethiopian_mss').to_s }
  let(:csv_import) { FactoryBot.create(:csv_import, user: user, manifest: manifest, import_file_path: import_file_path) }
  let(:manifest) { Rack::Test::UploadedFile.new(Rails.root.join(csv_file), 'text/csv') }
  let(:user) { FactoryBot.create(:admin) }

  before do
    test_strategy = Flipflop::FeatureSet.current.test!
    test_strategy.switch!(:child_works, true)
  end

  context 'happy path for mss objects', :clean do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'multipage_mss', 'mss_sample.csv') }

    it 'imports expected objects, including children' do
      described_class.perform_now(csv_import.id)
      expected_objects_in_expected_order
    end
  end

  context 'the pages are defined before the work', :clean do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'multipage_mss', 'mss_sample_reordered.csv') }
    it 'imports expected objects' do
      described_class.perform_now(csv_import.id)
      expected_objects_in_expected_order
    end
  end

  def expected_objects_in_expected_order
    expect(CsvRow.count).to eq 6
    expect(Collection.count).to eq 1
    expect(Work.count).to eq 1
    expect(ChildWork.count).to eq 3
    collection = Collection.last
    work = Work.last
    expect(work.member_of_collections.first.id).to eq "x3xg9000zz-89112"

    # The work is attached to the Collection as expected
    expect(collection.child_works.count).to eq 1
    expect(collection.child_works.first.title.first).to eq "Ms. 50 Marbabeta Salomon, Ṣalota Susnyos"
    # The ChildWorks are attached to the Work as expected
    work = Work.last
    expect(work.members.size).to eq 3
    # It makes a PageOrder object for each ChildWork
    expect(PageOrder.count).to eq 3
    # It ensures the ChildWorks are in the right order
    expect(work.ordered_member_ids).to eq ["rm6zp100zz-89112", "cba-6h6zp100zz-89112", "zyx-6h6zp100zz-89112"]
  end
end
