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
      :binding_note,
      :caption,
      :collation,
      :composer,
      :dimensions,
      :dlcs_collection_name,
      :extent,
      :foliation,
      :funding_note,
      :genre,
      :geographic_coordinates,
      :iiif_manifest_url,
      :iiif_range,
      :illustrations_note,
      :iiif_viewing_hint,
      :illuminator,
      :local_identifier,
      :location,
      :lyricist,
      :medium,
      :named_subject,
      :normalized_date,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :provenance,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :scribe,
      :subject_topic,
      :summary,
      :support,
      :toc,
      :iiif_text_direction,
      :uniform_title,
      to: :solr_document
    )
  end
end
