# frozen_string_literal: true

class CreateManifestJob < ApplicationJob
  queue_as :default

  def perform(work_ark)
    work = Work.find_by_ark(work_ark) || ChildWork.find_by_ark(work_ark)
    raise(ArgumentError, "No such Work or ChildWork: #{work_ark}.") unless work

    Californica::ManifestBuilderService.new(curation_concern: work).persist
  end

  def deduplication_key
    "CreateManifestJob-#{arguments[0]}"
  end
end
