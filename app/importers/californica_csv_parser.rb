# frozen_string_literal: true

class CalifornicaCsvParser < Darlingtonia::CsvParser
  DEFAULT_VALIDATORS = [
    Darlingtonia::CsvFormatValidator.new,
    Darlingtonia::TitleValidator.new
  ].freeze

  def records
    return enum_for(:records) unless block_given?
    file.rewind
    actual_records_processed = 0
    expected_records_processed = 0
    # use the CalifornicaMapper
    CSV.parse(file.read, headers: true).each_with_index do |row, index|
      begin
        next if row.to_h.values.all?(&:nil?)
        yield Darlingtonia::InputRecord.from(metadata: row, mapper: CalifornicaMapper.new)
        actual_records_processed += 1
        expected_records_processed = index + 1 # index starts with 0, we want to start with 1
      rescue => e
        # TODO: Add honeybadger or other alerting service here
        Darlingtonia.config.default_info_stream.error "Error encountered ingesting row #{index}: #{row}"
        Darlingtonia.config.default_error_stream.error "Error encountered ingesting row #{index}: #{row}: #{e.backtrace}"
        next
      end
    end
    Darlingtonia.config.default_info_stream.info "Expected #{expected_records_processed} records"
    Darlingtonia.config.default_info_stream.info "Actually processed #{actual_records_processed} records"
  rescue CSV::MalformedCSVError
    # error reporting for this case is handled by validation
    []
  end
end
