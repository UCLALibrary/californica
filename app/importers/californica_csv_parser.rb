# frozen_string_literal: true

class CalifornicaCsvParser < Darlingtonia::CsvParser
  ##
  # @!attribute [rw] error_stream
  #   @return [#<<]
  # @!attribute [rw] info_stream
  #   @return [#<<]
  attr_accessor :error_stream, :info_stream, :import_file_path

  ##
  # @todo should error_stream and info_stream be moved to the base
  #   `Darlingtonia::Parser`?
  #
  # @param [#<<] error_stream
  # @param [#<<] info_stream
  def initialize(file:,
                 import_file_path: ENV['IMPORT_FILE_PATH'] || '/opt/data',
                 error_stream: Darlingtonia.config.default_error_stream,
                 info_stream:  Darlingtonia.config.default_info_stream,
                 **opts)
    self.error_stream = error_stream
    self.info_stream  = info_stream
    @import_file_path = import_file_path

    self.validators = [
      Darlingtonia::CsvFormatValidator.new(error_stream: error_stream),
      CsvValidator.new(error_stream: error_stream),
      Darlingtonia::TitleValidator.new(error_stream: error_stream),
      RightsStatementValidator.new(error_stream: error_stream)
    ]

    super
  end

  # Skip this number of records before starting the ingest process. Default is 0.
  # Useful for re-starting a failed ingest without having to blow everything away.
  def skip
    return 0 unless ENV['SKIP']
    ENV['SKIP'].to_s.to_i
  end

  def headers
    return @headers if @headers
    file.rewind
    first_row = file.readline
    @headers = CSV.parse(first_row, headers: true, return_headers: true).headers
  rescue CSV::MalformedCSVError
    # This error will be handled by Darlingtonia::CsvFormatValidator
    []
  end

  def records
    return enum_for(:records) unless block_given?
    file.rewind
    # use the CalifornicaMapper
    CSV.parse(file.read, headers: true).each_with_index do |row, index|
      next unless index >= skip
      next if row.to_h.values.all?(&:nil?)
      yield Darlingtonia::InputRecord.from(metadata: row, mapper: CalifornicaMapper.new(import_file_path: @import_file_path))
    end
  rescue CSV::MalformedCSVError
    # error reporting for this case is handled by validation
    []
  end
end
