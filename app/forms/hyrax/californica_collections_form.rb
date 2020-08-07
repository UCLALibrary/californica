# frozen_string_literal: true

module Hyrax
  class CalifornicaCollectionsForm < Hyrax::Forms::CollectionForm
    self.terms += [
      :alternative_title,
      :ark,
      :extent,
      :architect,
      :binding_note,
      :calligrapher,
      :caption,
      :collation,
      :colophon,
      :commentator,
      :composer,
      :condition_note,
      :dimensions,
      :editor,
      :engraver,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :funding_note,
      :genre,
      :iiif_range,
      :iiif_manifest_url,
      :iiif_viewing_hint,
      :illuminator,
      :illustrator,
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
      :note,
      :opac_url,
      :page_layout,
      :photographer,
      :place_of_origin,
      :printmaker,
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
      :subject_geographic,
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
        :calligrapher,
        :caption,
        :colophon,
        :commentator,
        :contributor,
        :condition_note,
        :creator,
        :date_created,
        :dimensions,
        :editor,
        :engraver,
        :extent,
        :finding_aid_url,
        :funding_note,
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
        :note,
        :opac_url,
        :page_layout,
        :photographer,
        :place_of_origin,
        :printmaker,
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
        :subject_geographic,
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
