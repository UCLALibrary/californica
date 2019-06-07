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
  json.canvases @sets do |child|
    json.set! :@id, "#{@root_url}/canvas/#{child.id}"
    json.set! :@type, 'sc:Canvas'
    json.label child.title.first
    json.description child.description.first
    json.width 640
    json.height 480
    json.images [child] do |child_image|
      file_set_id = if child_image.try(:file_sets)
                      child_image.file_sets.first.id
                    else
                      child_image.id
                    end

      original_file = ::FileSet.find(file_set_id).original_file

      url = Hyrax.config.iiif_image_url_builder.call(
        original_file.id,
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
          json.set! :@id, "#{request.base_url}/images/#{CGI.escape(original_file.id)}"
          json.profile 'http://iiif.io/api/image/2/level2.json'
        end
      end
      json.on "#{request.base_url}/concern/works/#{@solr_doc.id}/manifest/canvas/#{child.id}"
    end
  end
end
