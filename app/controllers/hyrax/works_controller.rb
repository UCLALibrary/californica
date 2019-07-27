# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # Generated controller for Work
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Work

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::WorkPresenter

    # Override from Hyrax. Because we are using ark-based identifiers we need to both
    # destroy and eradicate an object when it is deleted. Otherwise, a tombstone resource
    # is left in fedora and we cannot re-create an object that has the same ark.
    def destroy
      title = curation_concern.to_s
      return unless curation_concern&.destroy&.eradicate
      Hyrax.config.callback.run(:after_destroy, curation_concern.id, current_user)
      after_destroy_response(title)
    end

    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
      authorize! :show, curation_concern
      manifest_builder
    end

    def manifest_builder
      @solr_doc = ::SolrDocument.find(params[:id])
      date_modified = @solr_doc[:date_modified_dtsi] || @solr_doc[:system_create_dtsi]
      key = date_modified.to_datetime.strftime('%Y-%m-%d_%H-%M-%S') + @solr_doc[:id]

      if File.exist?(Rails.root.join('tmp', key)) && Flipflop.cache_manifests?
        render_manifest_file(key: key)
      else
        curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
        builder_service = Californica::ManifestBuilderService.new(curation_concern: curation_concern)
        @image_concerns = builder_service.image_concerns
        @root_url = builder_service.root_url

        manifest_json = render_to_string('/manifest.json')
        persist_manifest(key: key, json: manifest_json) if Flipflop.cache_manifests?
        render json: manifest_json
      end
    end

    private

      def render_manifest_file(key:)
        manifest_file = File.open(Rails.root.join('tmp', key))
        render json: manifest_file.read
        manifest_file.close
      end

      def persist_manifest(key:, json:)
        File.open(Rails.root.join('tmp', key), 'w+') do |f|
          f.write json
        end
      end
  end
end
