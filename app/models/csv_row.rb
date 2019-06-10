# frozen_string_literal: true
class CsvRow < ApplicationRecord
  serialize :job_ids_queued, Array
  serialize :job_ids_completed, Array
  serialize :job_ids_errored, Array
  serialize :error_messages, Array
end
