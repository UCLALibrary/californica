# frozen_string_literal: true
module Californica
  class ManifestBuilderService
    attr_accessor :curation_concern

    def initialize(curation_concern:)
      @curation_concern = curation_concern
    end

    def render
      renderer.render template: '/manifest.json',
                      assigns: { root_url: root_url,
                                 solr_doc: SolrDocument.find(@curation_concern.id),
                                 image_concerns: image_concerns }
    end

    def filesystem_cache_key
      date_modified = @curation_concern.date_modified
      date_modified = date_modified.to_datetime.strftime('%Y-%m-%d_%H-%M-%S') unless date_modified.nil?
      date_modified.to_s + @curation_concern.id
    rescue TypeError
      raise 'Cannot persist a IIIF manifest without an object ID. Did you forget to save this object?'
    end

    def iiif_url
      if !(@curation_concern.respond_to? :access_copy) || @curation_concern.access_copy.nil?
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

    def persist
      File.open(Rails.root.join('tmp', filesystem_cache_key), 'w+') do |f|
        f.write render
      end
    end

    def root_url
      "http://#{ENV['RAILS_HOST'] || 'localhost'}/concern/works/#{@curation_concern.id}/manifest"
    end

    private

      def renderer
        Hyrax::WorksController.renderer
      end
  end
end
