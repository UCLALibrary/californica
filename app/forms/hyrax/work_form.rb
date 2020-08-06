# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # Generated form for Work
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [
      :access_copy,
      :alternative_title,
      :architect,
      :ark,
      :binding_note,
      :author,
      :calligrapher,
      :caption,
      :collation,
      :colophon,
      :composer,
      :commentator,
      :condition_note,
      :dimensions,
      :editor,
      :engraver,
      :extent,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :funding_note,
      :genre,
      :iiif_manifest_url,
      :iiif_range,
      :iiif_viewing_hint,
      :illuminator,
      :illustrations_note,
      :illustrator,
      :latitude,
      :license,
      :local_identifier,
      :location,
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
      :preservation_copy,
      :printmaker,
      :representative_image,
      :provenance,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :rubricator,
      # :local_rights_statement, # This invokes License renderer from hyrax gem
      :scribe,
      :subject_topic,
      :subject_geographic,
      :subject_temporal,
      :summary,
      :support,
      :tagline,
      :toc,
      :translator,
      :iiif_text_direction,
      :uniform_title
    ]
    self.terms -= [:based_near]

    self.required_fields = [:title, :ark, :rights_statement]

    ##
    # Fields that are automatically drawn on the page above the fold
    #
    # @return [Enumerable<Symbol>] symbols representing each primary term
    def primary_terms
      primary = required_fields + [:access_copy, :preservation_copy]
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
