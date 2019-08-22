# frozen_string_literal: true
module Hyrax
  module Renderers
    class IiifViewingHintAttributeRenderer < Hyrax::Renderers::AttributeRenderer
      SERVICE = Californica::IiifViewingHintService

      ##
      # @private
      def attribute_value_to_html(value)
        SERVICE.label(value)
      rescue SERVICE::LookupError
        value
      end
    end
  end
end
