# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::ManifestActor do
  let(:actor) { described_class.new(next_actor) }
  let(:attrs) { { 'ark' => 'ark:/abc/123' } }
  let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: work, attributes: attrs) }
  let(:next_actor) { instance_double('Hyrax::Actors::BaseActor', create: true, update: true, destroy: true) }
  let(:work) { FactoryBot.build(:work, attrs) }

  before { ActiveJob::Base.queue_adapter = :test }

  describe '#create' do
    it 'enqueues a CreateManifestJob' do
      actor.create(env)
      expect(CreateManifestJob).to have_been_enqueued
    end
  end

  describe '#destroy' do
    let(:iiif_manifest_url) { 'http://iiif.test/url' }

    context 'when the work has a iiif_manifest_url set' do
      let(:attrs) { { 'ark' => 'ark:/abc/123', iiif_manifest_url: iiif_manifest_url } }

      it 'sends a DEL to the manifest-store service' do
        stubbed_request = stub_request(:delete, iiif_manifest_url).to_return(status: 200)
        actor.destroy(env)
        expect(stubbed_request).to have_been_requested
      end
    end

    context 'when the work does not have a iiif_manifest_url set' do
      let(:attrs) { { 'ark' => 'ark:/abc/123' } }

      it 'does nothing' do
        stubbed_request = stub_request(:delete, iiif_manifest_url).to_return(status: 200)
        actor.destroy(env)
        expect(stubbed_request).not_to have_been_requested
      end
    end
  end

  describe '#update' do
    it 'enqueues a CreateManifestJob' do
      actor.create(env)
      expect(CreateManifestJob).to have_been_enqueued
    end
  end
end
