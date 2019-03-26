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
