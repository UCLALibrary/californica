# frozen_string_literal: true
module Hyrax
  module Renderers
    class IiifTextDirectionAttributeRenderer < Hyrax::Renderers::AttributeRenderer
      SERVICE = Californica::IiifTextDirectionService

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
