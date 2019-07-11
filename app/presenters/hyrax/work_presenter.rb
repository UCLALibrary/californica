# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    delegate(
      :alternative_title,
      :architect,
      :ark,
      :caption,
      :dimensions,
      :dlcs_collection_name,
      :extent,
      :funding_note,
      :genre,
      :geographic_coordinates,
      :local_identifier,
      :location,
      :master_file_path,
      :medium,
      :named_subject,
      :normalized_date,
      :photographer,
      :place_of_origin,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :support,
      :uniform_title,
      to: :solr_document
    )
  end
end
