# frozen_string_literal: true

class CsvValidator < Darlingtonia::Validator
  def run_validation(parser:, **)
    errors = []

    missing_headers = required_headers - parser.headers
    unless missing_headers.blank?
      errors << Error.new(self, :missing_headers, "Missing required columns in CSV file: #{missing_headers.join(', ')}")
    end

    errors
  end

  def required_headers
    ['Title', 'Item Ark']
  end
end
