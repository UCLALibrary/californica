# frozen_string_literal: true

class RightsStatementValidator < Darlingtonia::Validator
  def run_validation(parser:, **)
    parser.records.each_with_object([]) do |record, errors|
      parsed_values = record.respond_to?(:rights_statement) ? Array(record.rights_statement) : []

      invalid_values = parsed_values - valid_values

      unless invalid_values.blank?
        errors << Error.new(record, :invalid_rights_statement, "The 'Rights.copyrightStatus' field contains an invalid value.  If this value is correct, you'll need to update 'config/authorities/rights_statements.yml' to allow this new value.  The invalid values are: #{invalid_values.join(', ')}")
      end
    end
  end

  # Hyrax expects the rights_statement to be a valid
  # value as defined in:
  # config/authorities/rights_statements.yml.
  def valid_values
    @valid_values ||= Qa::Authorities::Local.subauthority_for('rights_statements').all.map { |term| term['id'] }
  end
end
