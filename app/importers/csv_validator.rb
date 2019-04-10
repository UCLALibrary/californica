# frozen_string_literal: true

class CsvValidator < Darlingtonia::Validator
  def run_validation(parser:, **)
    errors = []
    missing_required_headers(parser, errors)
    errors
  end

  def missing_required_headers(parser, errors)
    missing_headers = required_headers - parser.headers
    return if missing_headers.blank?
    errors << Error.new(self, :missing_headers, "Missing required columns in CSV file: #{missing_headers.join(', ')}")
  end

  def required_headers
    CalifornicaMapper.required_headers
  end

  def allowed_headers
    CalifornicaMapper.allowed_headers
  end
end
