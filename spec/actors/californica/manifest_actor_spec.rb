# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Californica::ManifestActor do
  let(:actor) { described_class.new(next_actor) }
  let(:attrs) { { 'ark' => 'ark:/abc/123' } }
  let(:child_attrs) { { 'ark' => 'ark:/abc/456' } }
  let(:child_work) do
    child = FactoryBot.build(:child_work, child_attrs)
    allow(child).to receive(:member_of).and_return([work])
    child
  end
  let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: work, attributes: attrs) }
  let(:next_actor) { instance_double('Hyrax::Actors::BaseActor', create: true, update: true, destroy: true) }
  let(:work) { FactoryBot.build(:work, attrs) }

  before { ActiveJob::Base.queue_adapter = :test }

  describe '#create' do
    before { actor.create(env) }

    it 'enqueues a CreateManifestJob' do
      expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
    end

    context 'when there is a parent work' do
      let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: child_work, attributes: child_attrs) }

      it 'enqueues a CreateManifestJob for the child work' do
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/456')
      end

      it 'enqueues a CreateManifestJob for the parent' do
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
      end
    end

    context 'when there is a parent collection' do
      let(:env) do
        collection = FactoryBot.build(:collection, ark: 'ark/xyz/321')
        allow(work).to receive(:member_of).and_return([collection])
        instance_double('Hyrax::Actors::Environment', curation_concern: work, attributes: attrs)
      end

      it 'does not enque a CreateManifestJob for the collection' do
        expect(CreateManifestJob).not_to have_been_enqueued.with('ark/xyz/321')
      end
    end

    context 'when env.curation_concern is nil' do
      let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: nil, attributes: attrs) }

      it 'uses the ark from env.attributes' do
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
      end
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

    context 'when there is a parent work' do
      let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: child_work, attributes: child_attrs) }

      it 'enqueues a CreateManifestJob for the parent' do
        actor.destroy(env)
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
      end
    end
  end

  describe '#update' do
    before { actor.update(env) }

    it 'enqueues a CreateManifestJob' do
      expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
    end

    context 'when there is a parent work' do
      let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: child_work, attributes: child_attrs) }

      it 'enqueues a CreateManifestJob for the child work' do
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/456')
      end

      it 'enqueues a CreateManifestJob for the parent' do
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
      end
    end

    context 'when there is a parent collection' do
      let(:env) do
        collection = FactoryBot.build(:collection, ark: 'ark/xyz/321')
        allow(work).to receive(:member_of).and_return([collection])
        instance_double('Hyrax::Actors::Environment', curation_concern: work, attributes: attrs)
      end

      it 'does not enque a CreateManifestJob for the collection' do
        expect(CreateManifestJob).not_to have_been_enqueued.with('ark/xyz/321')
      end
    end

    context 'when env.curation_concern is nil' do
      let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: nil, attributes: attrs) }

      it 'uses the ark from env.attributes' do
        expect(CreateManifestJob).to have_been_enqueued.with('ark:/abc/123')
      end
    end
  end
end
