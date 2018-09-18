# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # Generated form for Work
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [:resource_type, :extent, :caption, :dimensions,
                   :funding_note, :genre, :latitude,
                   :longitude, :local_identifier, :medium,
                   :named_subject, :normalized_date, :repository,
                   :rights_country, :rights_holder]
  end
end
