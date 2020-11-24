module Californica
    class IiifService
        def src(iiif_manifest_url)
            iiif_manifest_url.sub('http:', 'https:')
            "https://t-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            end
        end
    end
end