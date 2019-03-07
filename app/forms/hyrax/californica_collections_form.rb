# frozen_string_literal: true

module Hyrax
  class CalifornicaCollectionsForm < Hyrax::Forms::CollectionForm
    self.terms += [:resource_type, :extent, :caption,
                   :dimensions, :funding_note, :genre,
                   :latitude, :longitude,
                   :local_identifier, :medium,
                   :named_subject, :normalized_date,
                   :repository, :location,
                   :rights_country, :rights_holder, :photographer]

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
