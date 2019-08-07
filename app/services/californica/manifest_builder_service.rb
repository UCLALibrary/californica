# frozen_string_literal: true
module Californica
  class ManifestBuilderService
    attr_accessor :curation_concern

    def initialize(curation_concern:)
      @curation_concern = curation_concern
    end

    def image_concerns
      @image_concerns ||= ([@curation_concern] + @curation_concern.ordered_members.to_a).select { |member| member.respond_to?(:access_copy) && member.access_copy }
    end

    def root_url
      "http://#{ENV['RAILS_HOST'] || 'localhost'}/concern/works/#{@curation_concern.id}/manifest"
    end
  end
end
