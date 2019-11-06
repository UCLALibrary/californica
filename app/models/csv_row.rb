# frozen_string_literal: true
class CsvRow < ApplicationRecord
  serialize :job_ids_queued, Set
  serialize :job_ids_completed, Set
  serialize :job_ids_errored, Set
  serialize :error_messages, Array
  validates :row_number, uniqueness: { scope: :csv_import_id, message: 'row_number and csv_import must be unique together' }
end
