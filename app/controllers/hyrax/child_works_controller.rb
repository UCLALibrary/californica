# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work ChildWork`
module Hyrax
  # Generated controller for ChildWork
  class ChildWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::ChildWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::WorkPresenter
=begin
    # Override from Hyrax. Because we are using ark-based identifiers we need to both
    # destroy and eradicate an object when it is deleted. Otherwise, a tombstone resource
    # is left in fedora and we cannot re-create an object that has the same ark.
    def destroy
      title = curation_concern.to_s
      return unless curation_concern&.destroy&.eradicate
      Hyrax.config.callback.run(:after_destroy, curation_concern.id, current_user)
      after_destroy_response(title)
    end
=end
  end
end
