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

    def manifest_builder
      @solr_doc = ::SolrDocument.find(params[:id])
      date_modified = @solr_doc[:date_modified_dtsi] || @solr_doc[:system_create_dtsi]
      key = date_modified.to_datetime.strftime('%Y-%m-%d_%H-%M-%S') + @solr_doc[:id]
      redis = Redis.current

      if redis.get(key)
        render json: redis.get(key)
      else
        curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
        builder_service = Californica::ManifestBuilderService.new(curation_concern: curation_concern)
        @sets = builder_service.sets
        @root_url = "#{request.protocol}#{request.host_with_port}/concern/works/#{@solr_doc.id}/manifest"
        redis.set(key, render_to_string('/manifest.json'))
        render json: redis.get(key)
      end
    end

    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Cache-Control'] = 'max_age=86400'
      curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
      authorize! :show, curation_concern
      manifest_builder
    end
  end
end
