# frozen_string_literal: true
module Hyrax
  module Dashboard
    module CollectionsControllerOverride
      # Use the local CalifornicaCollectionsForm, which includes all of the UCLA Metadata fields
      def form_class
        Hyrax::CalifornicaCollectionsForm
      end
    end
  end
end
