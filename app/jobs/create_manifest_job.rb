# frozen_string_literal: true

class CreateManifestJob < ApplicationJob
  queue_as :default

  def perform(work_ark)
    work = ActiveFedora::Base.where(ark: work_ark)
    Californica::ManifestBuilderService.new(curation_concern: work).persist
  end
end
