# frozen_string_literal: true
module Hyrax
  module Renderers
    class MastersRenderer < Hyrax::Renderers::AttributeRenderer
      ##
      # @private
      def attribute_value_to_html(value)
        if ENV['MASTERS_DIR']
          link_to(value, value.gsub(/^masters.in.library.ucla.edu\//, '/masters/'))
        else
          value
        end
      end
    end
  end
end
