# frozen_string_literal: true

module Hyrax
  class CalifornicaCollectionsForm < Hyrax::Forms::CollectionForm
    self.terms += [:ark, :resource_type, :extent, :caption,
                   :dimensions, :funding_note, :genre,
                   :latitude, :longitude,
                   :local_identifier, :medium,
                   :named_subject, :normalized_date,
                   :repository, :location,
                   :rights_country, :rights_holder, :photographer]

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
        :creator,
        :contributor,
        :keyword,
        :license,
        :publisher,
        :date_created,
        :subject,
        :language,
        :identifier,
        :based_near,
        :related_url,
        :resource_type,
        :extent,
        :caption,
        :dimensions,
        :funding_note,
        :genre,
        :latitude,
        :longitude,
        :local_identifier,
        :medium,
        :named_subject,
        :normalized_date,
        :repository,
        :location,
        :rights_country,
        :rights_holder,
        :photographer
      ]
    end
  end
end
