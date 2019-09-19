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

      def build_manifest(env)
        CreateManifestJob.perform_later(env.attributes['ark'])
      end

      def delete_manifest(env)
        manifest_url = env.curation_concern.iiif_manifest_url
        HTTParty.delete(manifest_url) if manifest_url
      end
  end
end
