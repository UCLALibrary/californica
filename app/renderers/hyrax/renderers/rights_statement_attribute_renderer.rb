module Hyrax
  module Renderers
    # This is used by PresentsAttributes to show licenses
    #   e.g.: presenter.attribute_to_html(:rights_statement, render_as: :rights_statement)
    class RightsStatementAttributeRenderer < AttributeRenderer
      private

        ##
        # Override Hyrax's default behavior to link copyright to the URI.
        # In UCLA's case, we are using a non-resolving placeholder URI. Note
        # that we should NOT use rightsstatement.org URIs until there is
        # an administrative policy in place approving their use.
        def attribute_value_to_html(value)
          Hyrax.config.rights_statement_service_class.new.label(value) { value }
        end
    end
  end
end
