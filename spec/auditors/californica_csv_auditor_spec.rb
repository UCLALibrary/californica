# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.xdescribe CalifornicaCsvAuditor, :clean do
#   subject(:auditor) { described_class.new(file: file, error_stream: []) }
#   let(:file)        { File.open(csv_path) }
#   let(:csv_path)    { 'spec/fixtures/example.csv' }
#   let(:record)      { FactoryBot.create(:work, id: 'w4qn2000zz-89112', ark: 'ark:/21198/zz0002nq4w') }
#   let(:record2)     { FactoryBot.create(:work, id: 'abcxyz', ark: 'ark:/21198/zz0002nq4w') }
#   let(:import_path) { File.join(fixture_path, 'clusc_1_1_00010432a.tif') }
#   let(:file_set_1)  { FactoryBot.create(:file_set, import_url: import_path) }
#   let(:file_set_2)  { FactoryBot.create(:file_set, import_url: import_path) }

#   context 'when there are too many FileSets' do
#     before do
#       record.ordered_members << file_set_1
#       record.ordered_members << file_set_2
#     end

#     it 'logs an error' do
#       auditor.audit
#       expect(auditor.error_stream).to contain_exactly("ark:/21198/zz0002nq4w id=w4qn2000zz-89112: expected 1 files, found 2")
#     end
#   end

#   context 'when there are too few FileSets' do
#     before do
#       record
#     end

#     it 'logs an error' do
#       auditor.audit
#       expect(auditor.error_stream).to contain_exactly("ark:/21198/zz0002nq4w id=w4qn2000zz-89112: expected 1 files, found 0")
#     end
#   end

#   context 'when there are just enough FileSets' do
#     before do
#       record.ordered_members << file_set_1
#     end

#     it 'doesn\'t log any errors' do
#       auditor.audit
#       expect(auditor.error_stream).to eq []
#     end
#   end

#   context 'when there are too few records' do
#     # before do
#     #   record.ordered_members << file_set_1
#     # end

#     it 'logs an error' do
#       auditor.audit
#       expect(auditor.error_stream).to contain_exactly('Row 2: Found 0 matches for ark ark:/21198/zz0002nq4w')
#     end
#   end

#   context 'when there are too many records' do
#     before do
#       record.ordered_members << file_set_1
#       record2.ordered_members << file_set_1
#     end

#     it 'logs an error' do
#       auditor.audit
#       expect(auditor.error_stream).to contain_exactly('Row 2: Found 2 matches for ark ark:/21198/zz0002nq4w')
#     end
#   end
# end
