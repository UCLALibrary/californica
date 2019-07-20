# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # Generated form for Work
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [
      :alternative_title,
      :architect,
      :ark,
      :author,
      :caption,
      :dimensions,
      :extent,
      :funding_note,
      :genre,
      :latitude,
      :local_identifier,
      :location,
      :longitude,
      :master_file_path,
      :medium,
      :named_subject,
      :normalized_date,
      :photographer,
      :place_of_origin,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :summary,
      :support,
      :uniform_title
    ]

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
