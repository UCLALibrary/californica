module Californica
    class IiifService
        def http_sub(iiif_manifest_url)
            iiif_manifest_url.sub('http:', 'https:')
        end
        def src(iiif_manifest_url)
            if ENV['RAILS_HOST'] == 'localhost' || ENV['RAILS_HOST'] == 'californica-test.library.ucla.edu'
                "https://t-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(http_sub(iiif_manifest_url))}"
            elsif ENV['RAILS_HOST'] == 'californica-dev.library.ucla.edu'
                "https://d-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(http_sub(iiif_manifest_url))}"
            elsif ENV['RAILS_HOST'] == 'californica-stage.library.ucla.edu'
                "https://s-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(http_sub(iiif_manifest_url))}"
            elsif ENV['RAILS_HOST'] == 'californica.library.ucla.edu'
                "https://p-w-dl-viewer01.library.ucla.edu/uv.html#?manifest=#{CGI.escape(http_sub(iiif_manifest_url))}"
            end
        end
    end
end


