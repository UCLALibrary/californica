# frozen_string_literal: true

class CalifornicaCsvAuditor < Darlingtonia::CsvParser
  attr_accessor :error_stream, :info_stream, :row_auditors

  def initialize(file:,
                 error_stream: Darlingtonia.config.default_error_stream,
                 info_stream:  Darlingtonia.config.default_info_stream,
                 **opts)
    self.error_stream = error_stream
    self.info_stream  = info_stream

    self.row_auditors = [
      FileCountAuditor.new(error_stream: error_stream, info_stream: info_stream)
    ]

    super
  end

  def audit
    # Use the CalifornicaMapper to extract an ark.
    # Match on ark. For every ark in the file, find the corresponding object
    # and audit it.
    CSV.parse(file.read, headers: true).each_with_index do |row, index|
      row_number = index + 2 # +1 to escape 0-based-indexing, +1 for skipped header row

      item = Darlingtonia::InputRecord.from(metadata: row, mapper: CalifornicaMapper.new)
      ark = item.mapper.metadata["Item ARK"]
      next unless ark
      ark = Ark.ensure_prefix(ark)

      records = ActiveFedora::Base.where(ark_ssi: ark)

      error_stream << "Row #{row_number}: Found #{records.length} matches for ark #{ark}" if records.length != 1

      records.each do |record|
        row_auditors.each do |row_auditor|
          row_auditor.audit(record, row)
        end
      end
    end

    # info_stream << "Actually processed #{actual_records_processed} records"
  rescue CSV::MalformedCSVError
    # error reporting for this case is handled by validation
    []
  end
end
