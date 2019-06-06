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
end
