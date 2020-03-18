# frozen_string_literal: true
module Hyrax
  class CalifornicaCollectionPresenter < Hyrax::CollectionPresenter
    # Terms is the list of fields displayed by
    # app/views/collections/_show_descriptions.html.erb
    def self.terms
      [
        :alternative_title,
        :architect,
        :ark,
        :author,
        :binding_note,
        :based_near,
        :creator,
        :commentator,
        :contributor,
        :caption,
        :collation,
        :composer,
        :condition_note,
        :date_created,
        :dimensions,
        :extent,
        :featured_image,
        :foliation,
        :funding_note,
        :genre,
        :iiif_manifest_url,
        :iiif_range,
        :illustrations_note,
        :iiif_viewing_hint,
        :identifier,
        :illuminator,
        :keyword,
        :location,
        :language,
        :latitude,
        :license,
        :longitude,
        :local_identifier,
        :lyricist,
        :masthead_parameters,
        :medium,
        :named_subject,
        :normalized_date,
        :opac_url,
        :page_layout,
        :photographer,
        :place_of_origin,
        :provenance,
        :publisher,
        :related_url,
        :representative_image,
        :repository,
        :rights_country,
        :rights_holder,
        # :local_rights_statement, # This invokes License renderer from hyrax gem
        :resource_type,
        :scribe,
        :services_contact,
        :size,
        :subject,
        :subject_geographic,
        :subject_temporal,
        :subject_topic,
        :support,
        :summary,
        :tagline,
        :iiif_text_direction,
        :translator,
        :toc,
        :total_items,
        :uniform_title
      ]
    end
  end
end
