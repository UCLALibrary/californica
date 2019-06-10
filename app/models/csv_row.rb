# frozen_string_literal: true
class CsvRow < ApplicationRecord
  serialize :job_ids_queued, Set
  serialize :job_ids_completed, Set
  serialize :job_ids_errored, Set
  serialize :error_messages, Array

  def status
    return "error" unless job_ids_errored.empty?
    return "queued" unless queued_but_not_completed.empty?
    return "complete" if queued_but_not_completed.empty?
    "unknown"
  end

  def queued_but_not_completed
    job_ids_queued - job_ids_completed
  end
end
