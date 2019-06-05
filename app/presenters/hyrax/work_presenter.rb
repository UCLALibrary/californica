# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    delegate :alternative_title, :ark, :resource_type, :extent,
             :architect, :caption, :dimensions, :dlcs_collection_name,
             :funding_note, :genre, :location, :geographic_coordinates,
             :medium, :local_identifier,
             :named_subject, :normalized_date, :photographer, :repository,
             :rights_country, :rights_holder, to: :solr_document
  end
end
