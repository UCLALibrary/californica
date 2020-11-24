module Californica
    class IiifService
        def src(iiif_manifest_url)
            if base_url.include?('localhost') || base_url.include?('californica-test')
                "https://t-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            elsif base_url.include?('californica-dev')
                "https://d-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            elsif base_url.include?('californica-stage')
                "https://s-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            elsif base_url.include?('californica')
                "https://p-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            end
        end
    end
end