# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Discoverable do
  before do
    class SomeKindOfWork < ActiveFedora::Base
      include ::Hyrax::WorkBehavior
      include ::Discoverable # We're testing this module
    end
  end

  after do
    Object.send(:remove_const, :SomeKindOfWork)
  end

  let(:test_work) { SomeKindOfWork.create!(visibility: starting_visibility) }

  context 'change visibility from "open" to "discovery"' do
    let(:starting_visibility) { 'open' }

    it 'sets the correct state' do
      # Starting values
      expect(test_work.visibility).to eq 'open'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq ['public']
      expect(test_work.discover_groups).to eq []

      # Set the visibility to the new value
      test_work.visibility = 'discovery'
      test_work.save!
      test_work.reload

      # Check that the new values are correct
      expect(test_work.visibility).to eq 'discovery'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq ['public']
    end
  end

  context 'change visibility from "authenticated" to "discovery"' do
    let(:starting_visibility) { 'authenticated' }

    it 'sets the correct state' do
      # Starting values
      expect(test_work.visibility).to eq 'authenticated'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq ['registered']
      expect(test_work.discover_groups).to eq []

      # Set the visibility to the new value
      test_work.visibility = 'discovery'
      test_work.save!
      test_work.reload

      # Check that the new values are correct
      expect(test_work.visibility).to eq 'discovery'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq ['public']
    end
  end

  context 'change visibility from "restricted" to "discovery"' do
    let(:starting_visibility) { 'restricted' }

    it 'sets the correct state' do
      # Starting values
      expect(test_work.visibility).to eq 'restricted'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq []

      # Set the visibility to the new value
      test_work.visibility = 'discovery'
      test_work.save!
      test_work.reload

      # Check that the new values are correct
      expect(test_work.visibility).to eq 'discovery'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq ['public']
    end
  end

  context 'change visibility from "discovery" to "authenticated"' do
    let(:starting_visibility) { 'discovery' }

    it 'sets the correct state' do
      # Starting values
      expect(test_work.visibility).to eq 'discovery'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq ['public']

      # Set the visibility to the new value
      test_work.visibility = 'authenticated'
      test_work.save!
      test_work.reload

      # Check that the new values are correct
      expect(test_work.visibility).to eq 'authenticated'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq ['registered']
      expect(test_work.discover_groups).to eq []
    end
  end

  context 'change visibility from "discovery" to "open"' do
    let(:starting_visibility) { 'discovery' }

    it 'sets the correct state' do
      # Starting values
      expect(test_work.visibility).to eq 'discovery'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq ['public']

      # Set the visibility to the new value
      test_work.visibility = 'open'
      test_work.save!
      test_work.reload

      # Check that the new values are correct
      expect(test_work.visibility).to eq 'open'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq ['public']
      expect(test_work.discover_groups).to eq []
    end
  end

  context 'change visibility from "discovery" to "restricted"' do
    let(:starting_visibility) { 'discovery' }

    it 'sets the correct state' do
      # Starting values
      expect(test_work.visibility).to eq 'discovery'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq ['public']

      # Set the visibility to the new value
      test_work.visibility = 'restricted'
      test_work.save!
      test_work.reload

      # Check that the discovery access has been removed
      expect(test_work.visibility).to eq 'restricted'
      expect(test_work.edit_groups).to eq []
      expect(test_work.read_groups).to eq []
      expect(test_work.discover_groups).to eq []
    end
  end

  # I don't know what is causing it, but in our
  # production-like environments, we're seeing some
  # duplicate entries in the access control groups.
  # Normally that should be harmless, but the
  # 'permissions_attributes=' method that we overrode
  # from hydra-access-controls gem doesn't behave
  # properly if there are duplicate entries, so I
  # added this test to cover that situation.
  # In the future we might want to dig into this
  # further and figure out where the duplicates are
  # coming from, but for now, since we have live data
  # with this problem, the code needs to handle it.
  describe 'permissions_attributes=' do
    context 'when the access groups have duplicate entries' do
      let(:test_work) do
        SomeKindOfWork.create!(
          edit_groups: ["admin"],
          read_groups: ["registered", "registered"],
          discover_groups: ["public"]
        )
      end

      let(:new_permissions) do
        [
          { name: "admin", type: "group", access: "edit" },
          { name: "public", type: "group", access: "discover" },
          { name: "registered", type: "group", access: "read", _destroy: true },
          { name: "registered", type: "group", access: "read", _destroy: true }
        ]
      end

      before do
        test_work.permissions_attributes = new_permissions
        test_work.save!
        test_work.reload
      end

      it 'sets the correct access permissions' do
        expect(test_work.edit_groups).to eq ['admin']
        expect(test_work.read_groups).to eq []
        expect(test_work.discover_groups).to eq ['public']
        expect(test_work.visibility).to eq 'discovery'
      end
    end
  end
end
