# frozen_string_literal: true

class FileCountAuditor
  attr_accessor :error_stream, :info_stream

  def initialize(error_stream: Darlingtonia.config.default_error_stream,
                 info_stream:  Darlingtonia.config.default_info_stream)
    self.error_stream = error_stream
    self.info_stream  = info_stream
  end

  def audit(stored_record, csv_row)
    info_stream << "auditing #{stored_record.ark}"
    n_expected = csv_row["File Name"].to_s.split('|~|').count
    n_stored = stored_record.respond_to?(:file_sets) ? stored_record.file_sets.count : 0

    error_stream << "#{stored_record.ark} id=#{stored_record.id}: expected #{n_expected} files, found #{n_stored}" if n_stored != n_expected
  end
end
