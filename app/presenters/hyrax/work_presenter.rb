# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    delegate :alternative_title, :ark, :resource_type, :extent, :architect, :caption, :dimensions,
             :dlcs_collection_name, :funding_note, :genre, :geographic_coordinates,
             :local_identifier, :location, :medium,
             :named_subject, :normalized_date, :photographer, :place_of_origin,
             :repository, :rights_country, :rights_holder, to: :solr_document
  end
end
