# frozen_string_literal: true

module Hyrax
  class CalifornicaCollectionsForm < Hyrax::Forms::CollectionForm
    self.terms += [
      :alternative_title,
      :ark,
      :artist,
      :extent,
      :architect,
      :binding_note,
      :calligrapher,
      :caption,
      :cartographer,
      :collation,
      :colophon,
      :commentator,
      :composer,
      :condition_note,
      :content_disclaimer,
      :contents_note,
      :dimensions,
      :director,
      :editor,
      :engraver,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :funding_note,
      :genre,
      :iiif_range,
      :iiif_manifest_url,
      :iiif_text_direction,
      :iiif_viewing_hint,
      :illuminator,
      :illustrator,
      :illustrations_note,
      :interviewer,
      :interviewee,
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
      :producer,
      :program,
      :provenance,
      :recipient,
      :repository,
      :representative_image,
      :resource_type,
      :rights_country,
      :rights_holder,
      :rubricator,
      # :local_rights_statement, # This invokes License renderer from hyrax gem
      :scribe,
      :services_contact,
      :subject_geographic,
      :subject_temporal,
      :subject_topic,
      :tagline,
      :thumbnail_link,
      :summary,
      :toc,
      :translator,
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
        :artist,
        :binding_note,
        :based_near,
        :calligrapher,
        :caption,
        :cartographer,
        :collation,
        :colophon,
        :commentator,
        :composer,
        :condition_note,
        :content_disclaimer,
        :contents_note,
        :contributor,
        :creator,
        :date_created,
        :dimensions,
        :director,
        :editor,
        :engraver,
        :extent,
        :featured_image,
        :finding_aid_url,
        :foliation,
        :funding_note,
        :genre,
        :identifier,
        :iiif_manifest_url,
        :iiif_range,
        :iiif_text_direction,
        :iiif_viewing_hint,
        :illuminator,
        :illustrations_note,
        :interviewer,
        :interviewee,
        :keyword,
        :language,
        :latitude,
        :license,
        :location,
        :local_identifier,
        :longitude,
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
        :producer,
        :program,
        :provenance,
        :publisher,
        :recipient,
        :related_url,
        :repository,
        :representative_image,
        :resource_type,
        :rights_country,
        :rights_holder,
        :rubricator,
        :services_contact,
        # :local_rights_statement, # This invokes License renderer from hyrax gem
        :scribe,
        :subject,
        :subject_geographic,
        :subject_temporal,
        :subject_topic,
        :summary,
        :tagline,
        :thumbnail_link,
        :toc,
        :translator,
        :uniform_title,
      ]
    end
  end
end
