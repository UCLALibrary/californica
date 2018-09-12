# frozen_string_literal: true
module Schemas
  ##
  # An extension strategy to apply schema changes to the underlying AT model if it
  # has already been generated.
  class GeneratedResourceSchemaStrategy < ActiveFedora::SchemaIndexingStrategy
    ##
    # @see SchemaIndexingStrategy#apply
    def apply(object, property)
      result = super

      klass = object.instance_variable_get(:@generated_resource_class)
      return result unless klass
      klass.property property.name, property.to_h
      result
    end
  end
end
