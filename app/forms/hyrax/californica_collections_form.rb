# frozen_string_literal: true

module Hyrax
  class CalifornicaCollectionsForm < Hyrax::Forms::CollectionForm
    self.terms += [
      :alternative_title,
      :ark,
      :extent,
      :architect,
      :binding_note,
      :caption,
      :collation,
      :colophon,
      :commentator,
      :composer,
      :condition_note,
      :creator,
      :dimensions,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :funding_note,
      :genre,
      :iiif_range,
      :iiif_manifest_url,
      :iiif_viewing_hint,
      :illuminator,
      :illustrations_note,
      :latitude,
      :longitude,
      :local_identifier,
      :location,
      :lyricist,
      :masthead_parameters,
      :medium,
      :named_subject,
      :normalized_date,
      :page_layout,
      :photographer,
      :place_of_origin,
      :provenance,
      :repository,
      :representative_image,
      :resource_type,
      :rights_country,
      :rights_holder,
      :rubricator,
      # :local_rights_statement, # This invokes License renderer from hyrax gem
      :services_contact,
      :scribe,
      :subject_temporal,
      :subject_topic,
      :tagline,
      :summary,
      :toc,
      :translator,
      :iiif_text_direction,
      :uniform_title]

    self.required_fields = [:title, :ark]

    # Make some fields read-only
    def readonly?(field)
      readonly_fields = [:ark]
      # If there is no value set already, allow it to be set the first time
      return false if send(field).empty?
      # If a readonly field has a value set already, do not allow it to be edited
      return true if readonly_fields.include?(field)
      false
    end

    # Terms that appear above the accordion
    def primary_terms
      [:title, :ark, :description]
    end

    def secondary_terms
      [
        :architect,
        :binding_note,
        :based_near,
        :caption,
        :colophon,
        :commentator,
        :contributor,
        :creator,
        :condition_note,
        :date_created,
        :dimensions,
        :extent,
        :funding_note,
        :finding_aid_url,
        :genre,
        :identifier,
        :iiif_manifest_url,
        :iiif_range,
        :iiif_viewing_hint,
        :illustrations_note,
        :keyword,
        :language,
        :license,
        :latitude,
        :longitude,
        :local_identifier,
        :medium,
        :named_subject,
        :normalized_date,
        :page_layout,
        :photographer,
        :place_of_origin,
        :provenance,
        :publisher,
        :repository,
        :location,
        :related_url,
        :resource_type,
        :rights_country,
        :rights_holder,
        :rubricator,
        :services_contact,
        # :local_rights_statement, # This invokes License renderer from hyrax gem
        :subject,
        :subject_temporal,
        :subject_topic,
        :summary,
        :toc,
        :translator,
        :iiif_text_direction,
        :uniform_title,
        :collation,
        :composer,
        :foliation,
        :illuminator,
        :lyricist,
        :masthead_parameters,
        :representative_image,
        :featured_image,
        :tagline,
        :scribe,
      ]
    end
  end
end
