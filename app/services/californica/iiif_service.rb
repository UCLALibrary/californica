module Californica
    class IiifService
        def src(iiif_manifest_url)
            iiif_manifest_url.sub('http:', 'https:')
            if ENV['RAILS_HOST'] == 'localhost' || ENV['RAILS_HOST'] == 'californica-test'
                "https://t-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            elsif ENV['RAILS_HOST'] == 'californica-dev'
                "https://d-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            elsif ENV['RAILS_HOST'] == 'californica-stage'
                "https://s-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            elsif ENV['RAILS_HOST'] == 'californica'
                "https://p-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(iiif_manifest_url)}"
            end
        end
    end
end