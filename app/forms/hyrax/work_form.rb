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
      :medium,
      :named_subject,
      :normalized_date,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :repository,
      :resource_type,
      :rights_country,
      :rights_holder,
      :summary,
      :support,
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
