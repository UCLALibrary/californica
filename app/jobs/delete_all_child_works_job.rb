# frozen_string_literal: true
class DeleteAllChildWorksJob < ActiveJob::Base
  retry_on StandardError

  def perform
    while ChildWork.count.positive?
      start_time = Time.current
      record = ChildWork.first
      ark = record.ark
      Californica::Deleter.new(record: record).delete
      Rollbar.info("Deleted ChildWork", ark: ark, duration: ActiveSupport::Duration.build(Time.current - start_time), remaining: ChildWork.count)
    end

    Rollbar.info("No ChildWorks Remaining", remaining: ChildWork.count)
  end
end
