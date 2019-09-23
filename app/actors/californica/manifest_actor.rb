# frozen_string_literal: true

module Californica
  class ManifestActor < Hyrax::Actors::AbstractActor
    def create(env)
      build_manifest(env) && next_actor.create(env)
    end

    def destroy(env)
      delete_manifest(env) && next_actor.destroy(env)
    end

    def update(env)
      build_manifest(env) && next_actor.update(env)
    end

    private

      # Build the IIIF manifest for the work. If a @curation_concern is available in env, also build manifests for any parent works.
      def build_manifest(env)
        if env.curation_concern
          build_manifest_for_parent(env.curation_concern)
        else
          CreateManifestJob.perform_later(env.attributes['ark'])
        end
      end

      def build_manifest_for_parent(curation_concern)
        return unless curation_concern.is_a? Hyrax::WorkBehavior
        CreateManifestJob.perform_later(curation_concern.ark)
        curation_concern.member_of.each do |parent|
          build_manifest_for_parent(parent)
        end
      end

      def delete_manifest(env)
        manifest_url = env.curation_concern.iiif_manifest_url
        HTTParty.delete(manifest_url) if manifest_url
        env.curation_concern.member_of.each do |parent|
          build_manifest_for_parent(parent)
        end
      end
  end
end
