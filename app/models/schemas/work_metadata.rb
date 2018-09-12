# frozen_string_literal: true
module Schemas
  class WorkMetadata < ActiveTriples::Schema
    property :repository, predicate: RDF::Vocab::MODS.locationCopySublocation
  end
end
