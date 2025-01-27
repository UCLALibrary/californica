# frozen_string_literal: true
class DeleteAllChildWorksJob < ActiveJob::Base
  retry_on StandardError

  def perform
    while ChildWork.count.positive?
      start_time = Time.current
      record = ChildWork.first
      ark = record.ark
      Californica::Deleter.new(record: record).delete
    end

  end
end
