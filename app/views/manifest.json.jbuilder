# frozen_string_literal: true
require 'cgi'

json.set! :@context, 'http://iiif.io/api/presentation/2/context.json'
json.set! :@type, 'sc:Manifest'
json.set! :@id, @root_url
json.label @solr_doc.title.first
json.description @solr_doc.description.first

json.sequences [''] do
  json.set! :@type, 'sc:Sequence'
  json.set! :@id, "#{@root_url}/sequence/normal"
  json.canvases @image_concerns do |child|
    json.set! :@id, "#{@root_url}/canvas/#{child.id}"
    json.set! :@type, 'sc:Canvas'
    json.label child.title.first
    json.description child.description.first
    json.width 640
    json.height 480
    json.images [child] do |child_image|
      url = Hyrax.config.iiif_image_url_builder.call(
        CGI.escape(child_image.master_file_path),
        request.base_url,
        Hyrax.config.iiif_image_size_default
      )

      json.set! :@type, 'oa:Annotation'
      json.motivation 'sc:painting'
      json.resource do
        json.set! :@type, 'dctypes:Image'
        json.set! :@id, url
        json.width 640
        json.height 480
        json.service do
          json.set! :@context, 'http://iiif.io/api/image/2/context.json'

          # The base url for the info.json file
          info_url = Hyrax.config.iiif_info_url_builder.call(
            CGI.escape(child_image.master_file_path),
            ENV['IIIF_SERVER_URL'] || request.base_url
          )

          json.set! :@id, info_url
          json.profile 'http://iiif.io/api/image/2/level2.json'
        end
      end
      json.on "#{request.base_url}/concern/works/#{@solr_doc.id}/manifest/canvas/#{child.id}"
    end
  end
end
