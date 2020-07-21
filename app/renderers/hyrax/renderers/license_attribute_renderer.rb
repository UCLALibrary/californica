# frozen_string_literal: true
module Hyrax
  module Renderers
    class LicenseAttributeRenderer < Hyrax::Renderers::AttributeRenderer
      SERVICE = Californica::LicenseService

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
