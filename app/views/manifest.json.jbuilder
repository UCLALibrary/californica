# frozen_string_literal: true
require 'cgi'

json.set! :@context, 'http://iiif.io/api/presentation/2/context.json'
json.set! :@type, 'sc:Manifest'
json.set! :@id, @root_url
json.label @solr_doc.title.first
json.description @solr_doc.description.first
json.viewingDirection @builder_service.iiif_text_direction if @builder_service.iiif_text_direction

json.sequences [''] do
  json.set! :@type, 'sc:Sequence'
  json.set! :@id, "#{@root_url}/sequence/normal"
  json.canvases @image_concerns do |child|
    child_iiif_service = Californica::ManifestBuilderService.new(curation_concern: child)
    canvas_uri = "#{@root_url}/canvas/#{CGI.escape(child.ark)}"
    json.set! :@id, canvas_uri
    json.set! :@type, 'sc:Canvas'
    json.label child.title.first
    json.description child.description.first
    json.width 640
    json.height 480
    json.images [child] do
      json.set! :@type, 'oa:Annotation'
      json.motivation 'sc:painting'
      json.resource do
        json.set! :@type, 'dctypes:Image'
        json.set! :@id, child_iiif_service.iiif_url + '/full/600,/0/default.jpg'
        json.width 640
        json.height 480
        json.service do
          json.set! :@context, 'http://iiif.io/api/image/2/context.json'

          # The base url for the info.json file
          info_url = child_iiif_service.iiif_url

          json.set! :@id, info_url
          json.profile 'http://iiif.io/api/image/2/level2.json'
        end
      end
      json.on canvas_uri
    end
  end
end
