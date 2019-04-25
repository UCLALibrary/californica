# frozen_string_literal: true

class CalifornicaCsvCleaner < Darlingtonia::CsvParser
  ##
  # @!attribute [rw] error_stream
  #   @return [#<<]
  # @!attribute [rw] info_stream
  #   @return [#<<]
  attr_accessor :error_stream, :info_stream

  ##
  # @todo should error_stream and info_stream be moved to the base
  #   `Darlingtonia::Parser`?
  #
  # @param [#<<] error_stream
  # @param [#<<] info_stream
  def initialize(file:,
                 error_stream: Darlingtonia.config.default_error_stream,
                 info_stream:  Darlingtonia.config.default_info_stream,
                 **opts)
    self.error_stream = error_stream
    self.info_stream  = info_stream

    self.validators = [
      Darlingtonia::CsvFormatValidator.new(error_stream: error_stream),
      Darlingtonia::TitleValidator.new(error_stream: error_stream),
      RightsStatementValidator.new(error_stream: error_stream)
    ]

    super
  end

  def clean
    # Use the CalifornicaMapper to extract an ark.
    # Match on ark. For every ark in the file, find the corresponding object
    # and destroy it.
    CSV.parse(file.read, headers: true).each_with_index do |row, _index|
      item = Darlingtonia::InputRecord.from(metadata: row, mapper: CalifornicaMapper.new)
      ark = item.mapper.metadata["Item Ark"]
      next unless ark
      ark = Ark.ensure_prefix(ark)
      ActiveFedora::Base.where(ark_ssi: ark).each do |work|
        work&.destroy&.eradicate
      end
    end

    # info_stream << "Actually processed #{actual_records_processed} records"
  rescue CSV::MalformedCSVError
    # error reporting for this case is handled by validation
    []
  end
end
