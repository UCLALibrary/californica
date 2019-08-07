# frozen_string_literal: true
module Californica
  class ManifestBuilderService
    attr_accessor :curation_concern

    def initialize(curation_concern:)
      @curation_concern = curation_concern
    end

    def iiif_base_url
      if @curation_concern.access_copy.nil?
        nil
      elsif @curation_concern.access_copy.start_with?(/https?\:\/\//)
        @curation_concern.access_copy
      elsif @curation_concern.access_copy.start_with?(/ark\:\//)
        ENV['IIIF_SERVICE_URL'] + CGI.escape(@curation_concern.access_copy)
      else
        ENV['IIIF_SERVER_URL'] + CGI.escape(@curation_concern.access_copy)
      end
    end

    def image_concerns
      @image_concerns ||= ([@curation_concern] + @curation_concern.ordered_members.to_a).select { |member| member.respond_to?(:access_copy) && member.access_copy }
    end

    def root_url
      "http://#{ENV['RAILS_HOST'] || 'localhost'}/concern/works/#{@curation_concern.id}/manifest"
    end
  end
end
