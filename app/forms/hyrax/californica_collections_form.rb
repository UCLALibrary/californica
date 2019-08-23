# frozen_string_literal: true

module Hyrax
  class CalifornicaCollectionsForm < Hyrax::Forms::CollectionForm
<<<<<<< HEAD
    self.terms += [
      :alternative_title,
      :ark,
      :extent,
      :architect,
      :binding_note,
      :caption,
      :dimensions,
      :funding_note,
      :genre,
      :iiif_text_direction,
      :iiif_viewing_hint,
      :latitude,
      :longitude,
      :local_identifier,
      :location,
      :medium,
      :named_subject,
      :normalized_date,
      :page_layout,
      :photographer,
      :place_of_origin,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :services_contact,
      :subject_topic,
      :summary,
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
        :creator,
        :contributor,
        :date_created,
        :dimensions,
        :extent,
        :funding_note,
        :genre,
        :iiif_text_direction,
        :iiif_viewing_hint,
        :identifier,
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
        :publisher,
        :repository,
        :location,
        :related_url,
        :resource_type,
        :rights_country,
        :rights_holder,
        :services_contact,
        :subject,
        :subject_topic,
        :summary,
        :support,
        :uniform_title
      ]
    end
  end
end
