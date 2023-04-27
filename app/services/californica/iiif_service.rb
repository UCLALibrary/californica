# frozen_string_literal: true

module Californica
  class IiifService
    def http_sub(iiif_manifest_url)
      iiif_manifest_url.sub('http:', 'https:')
    end

    def src(iiif_manifest_url)
      "https://p-w-dl-viewer01.library.ucla.edu/#?manifest=#{CGI.escape(http_sub(iiif_manifest_url.to_s))}"
    end
  end
end
