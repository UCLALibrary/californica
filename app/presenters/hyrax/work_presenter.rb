# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    delegate(
      :access_copy,
      :alternative_title,
      :architect,
      :ark,
      :author,
      :caption,
      :dimensions,
      :dlcs_collection_name,
      :extent,
      :funding_note,
      :genre,
      :geographic_coordinates,
      :local_identifier,
      :location,
      :medium,
      :named_subject,
      :normalized_date,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :summary,
      :support,
      :uniform_title,
      to: :solr_document
    )
  end
end
