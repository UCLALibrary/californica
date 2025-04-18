# frozen_string_literal: true
# Generated via `rails generate hyrax:work Work`
module Hyrax
  # Generated form for Work
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [
      :access_copy,
      :alternative_title,
      :architect,
      :archival_collection_box,
      :archival_collection_folder,
      :archival_collection_number,
      :archival_collection_title,
      :ark,
      :arranger,
      :artist,
      :author,
      :binding_note,
      :calligrapher,
      :caption,
      :cartographer,
      :citation_source,
      :collation,
      :collector,
      :colophon,
      :commentator,
      :composer,
      :condition_note,
      :content_disclaimer,
      :contents_note,
      :contributor,
      # :creator,
      :dimensions,
      :director,
      :edition,
      :editor,
      :electronic_locator,
      :engraver,
      :extent,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :format_book,
      :funding_note,
      :genre,
      :history,
      :host,
      :iiif_manifest_url,
      :iiif_range,
      :iiif_text_direction,
      :iiif_viewing_hint,
      :illuminator,
      :illustrations_note,
      :illustrator,
      :inscription,
      :interviewee,
      :interviewer,
      :latitude,
      :librettist,
      :license,
      :local_identifier,
      :local_rights_statement,
      :location,
      :longitude,
      :lyricist,
      :masthead_parameters,
      :medium,
      :musician,
      :named_subject,
      :normalized_date,
      :note,
      :note_admin,
      :oai_set,
      :opac_url,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :printer,
      :printmaker,
      :producer,
      :program,
      :provenance,
      :recipient,
      :related_record,
      :related_to,
      :repository,
      :representative_image,
      :researcher,
      :resource_type,
      :resp_statement,
      :rights_country,
      :rights_holder,
      :rubricator,
      :scribe,
      :script,
      :series,
      :subject_cultural_object,
      :subject_domain_topic,
      :subject_geographic,
      :subject_temporal,
      :subject_topic,
      :summary,
      :support,
      :tagline,
      :thumbnail_link,
      :toc,
      :translator,
      :uniform_title
    ]
    self.terms -= [:based_near]
    self.required_fields = [:title, :ark, :rights_statement]

    # Fields that are automatically drawn on the page above the fol
    # @return [Enumerable<Symbol>] symbols representing each primary term
    def primary_terms
      primary = required_fields + [:access_copy, :preservation_copy, :thumbnail_link]
      primary = (primary & terms)

      (required_fields - primary).each do |missing|
        Rails.logger.warn("The form field #{missing} is configured as a " \
                          'required field, but not as a term. This can lead ' \
                          'to unexpected behavior. Did you forget to add it ' \
                          "to `#{self.class}#terms`?")
      end

      primary
    end

    # Make some fields read-only
    def readonly?(field)
      readonly_fields = [:ark]
      # If there is no value set already, allow it to be set the first time
      return false if send(field).empty?
      # If a readonly field has a value set already, do not allow it to be edited
      return true if readonly_fields.include?(field)
      false
    end
  end
end
