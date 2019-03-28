# frozen_string_literal: true

class CsvValidator < Darlingtonia::Validator
  def run_validation(parser:, **)
    errors = []
    missing_required_headers(parser, errors)
    unrecognized_headers(parser, errors)
    errors
  end

  def missing_required_headers(parser, errors)
    missing_headers = required_headers - parser.headers
    return if missing_headers.blank?
    errors << Error.new(self, :missing_headers, "Missing required columns in CSV file: #{missing_headers.join(', ')}")
  end

  def unrecognized_headers(parser, errors)
    unknown_headers = parser.headers - allowed_headers
    return if unknown_headers.blank?
    errors << Error.new(self, :unrecognized_headers, "The CSV file contains unknown columns: #{unknown_headers.join(', ')}")
  end

  def required_headers
    ['Title', 'Item Ark']
  end

  def allowed_headers
    CalifornicaMapper.allowed_headers
  end
end
