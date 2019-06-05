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

  let(:test_work) { SomeKindOfWork.create!(visibility: 'open') }

  it 'can set discovery-level visibility' do
    # Starting values, a publicly-visible record
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

    # Restrict access to the record
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
