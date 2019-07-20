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
        :based_near,
        :creator,
        :contributor,
        :caption,
        :date_created,
        :dimensions,
        :extent,
        :funding_note,
        :genre,
        :identifier,
        :keyword,
        :location,
        :language,
        :latitude,
        :license,
        :longitude,
        :local_identifier,
        :medium,
        :named_subject,
        :normalized_date,
        :photographer,
        :place_of_origin,
        :publisher,
        :related_url,
        :repository,
        :rights_country,
        :rights_holder,
        :resource_type,
        :services_contact,
        :size,
        :subject,
        :support,
        :summary,
        :total_items,
        :uniform_title
      ]
    end
  end
end
