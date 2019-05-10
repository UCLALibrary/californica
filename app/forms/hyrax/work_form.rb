# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # Generated form for Work
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [:ark, :resource_type, :extent, :architect, :caption,
                   :dimensions, :funding_note, :genre,
                   :latitude, :longitude,
                   :local_identifier, :medium,
                   :named_subject, :normalized_date,
                   :repository, :location,
                   :rights_country, :rights_holder, :photographer]

    self.required_fields = [:title, :ark, :rights_statement]

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
