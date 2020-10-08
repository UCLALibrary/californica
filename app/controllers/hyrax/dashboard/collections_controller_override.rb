# frozen_string_literal: true
module Hyrax
  module Dashboard
    module CollectionsControllerOverride
      def self.prepended(_base)
        Hyrax::CollectionsController.presenter_class = Hyrax::CalifornicaCollectionPresenter
        Hyrax::Dashboard::CollectionsController.presenter_class = Hyrax::CalifornicaCollectionPresenter
      end

      # Use the local CalifornicaCollectionsForm, which includes all of the UCLA Metadata fields
      def form_class
        Hyrax::CalifornicaCollectionsForm
      end
=begin
      # Override #destroy method from Hyrax. Because we are using ark based identifiers, we need to both
      # destroy and eradicate the object, so that we can re-create a collection object with the same ark if needed
      def destroy
        if @collection.destroy.eradicate
          after_destroy(params[:id])
        else
          after_destroy_error(params[:id])
        end
      end
=end

      # Override #create method from Hyrax to assign an ark based identifier to any newly created collection objects
      def create
        # Manual load and authorize necessary because Cancan will pass in all
        # form attributes. When `permissions_attributes` are present the
        # collection is saved without a value for `has_model.`
        @collection = ::Collection.new
        authorize! :create, @collection
        # Coming from the UI, a collection type gid should always be present.  Coming from the API, if a collection type gid is not specified,
        # use the default collection type (provides backward compatibility with versions < Hyrax 2.1.0)
        @collection.collection_type_gid = params[:collection_type_gid].presence || default_collection_type.gid
        @collection.id = Californica::IdGenerator.id_from_ark(collection_params["ark"])
        @collection.attributes = collection_params.except(:members, :parent_id, :collection_type_gid)
        @collection.apply_depositor_metadata(current_user.user_key)
        add_members_to_collection unless batch.empty?
        @collection.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE unless @collection.discoverable?
        if @collection.save
          after_create
        else
          after_create_error
        end
      end
    end
  end
end
