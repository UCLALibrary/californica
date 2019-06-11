# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InheritPermissionsJob, :clean do
  let(:work) do
    w = Work.new(title: ['A'], ark: 'ark:/123/work', visibility: work_vis)
    w.members = [fs]
    w.save!
    w
  end

  let(:fs) { FileSet.create(visibility: fs_vis) }
  let(:work_vis) { 'open' }
  let(:fs_vis) { 'discovery' }

  # This spec is meant to test the override of the
  # "permissions_attributes=" method from the
  # hydra-access-controls gem.
  describe 'when work has "open" and fileset has "discovery"' do
    it 'copies the permissions from the parent work' do
      # Expected starting state: fileset doesn't match parent work.
      expect(work.edit_groups).to eq []
      expect(fs.edit_groups).to eq []

      expect(work.read_groups).to eq ['public']
      expect(fs.read_groups).to eq []

      expect(work.discover_groups).to eq []
      expect(fs.discover_groups).to eq ['public']

      expect(work.visibility).to eq 'open'
      expect(fs.visibility).to eq 'discovery'

      # Run the job
      InheritPermissionsJob.perform_now(work)
      work.reload
      fs.reload

      # Check the resulting state: fileset should match the parent work
      expect(work.edit_groups).to eq []
      expect(fs.edit_groups).to eq []

      expect(work.read_groups).to eq ['public']
      expect(fs.read_groups).to eq ['public']

      expect(work.discover_groups).to eq []
      expect(fs.discover_groups).to eq []

      expect(work.visibility).to eq 'open'
      expect(fs.visibility).to eq 'open'
    end
  end
end
