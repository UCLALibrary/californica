# frozen_string_literal: true
class CsvRow < ApplicationRecord
  serialize :job_ids_queued, Set
  serialize :job_ids_completed, Set
  serialize :job_ids_errored, Set
  serialize :error_messages, Array
end
