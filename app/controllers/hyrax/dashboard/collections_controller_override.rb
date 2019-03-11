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
    end
  end
end
