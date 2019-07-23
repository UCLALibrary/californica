# frozen_string_literal: true
require "rails_helper"
require 'cgi'

RSpec.describe "manifest", type: :view do
  let(:master_file_path) { 'a/b.tif' }
  let(:work) { FactoryBot.create(:work, master_file_path: master_file_path) }
  let(:solr_doc) { SolrDocument.find(work.id) }
  let(:image_concerns) { Californica::ManifestBuilderService.new(curation_concern: work).image_concerns }

  before do
    assign(:root_url, 'http://localhost:3000/manifest')
    assign(:solr_doc, solr_doc)
    assign(:image_concerns, image_concerns)
  end

  it "displays a valid IIIF Presentation API manifest" do
    render
    iiif_id = CGI.escape(work.master_file_path)
    doc = <<~HEREDOC
{
  "@context": "http://iiif.io/api/presentation/2/context.json",
  "@type": "sc:Manifest",
  "@id": "http://localhost:3000/manifest",
  "label": "#{work.title.first}",
  "description": "#{work.description.first}",
  "sequences": [
    {
      "@type": "sc:Sequence",
      "@id": "http://localhost:3000/manifest/sequence/normal",
      "canvases": [
        {
          "@id": "http://localhost:3000/manifest/canvas/#{work.id}",
          "@type": "sc:Canvas",
          "label": "#{work.title.first}",
          "description": "#{work.description.first}",
          "width": 640,
          "height": 480,
          "images": [
            {
              "@type": "oa:Annotation",
              "motivation": "sc:painting",
              "resource": {
                "@type": "dctypes:Image",
                "@id": "#{ENV['IIIF_SERVER_URL']}#{iiif_id}/full/600,/0/default.jpg",
                "width": 640,
                "height": 480,
                "service": {
                  "@context": "http://iiif.io/api/image/2/context.json",
                  "@id": "#{ENV['IIIF_SERVER_URL']}#{iiif_id}",
                  "profile": "http://iiif.io/api/image/2/level2.json"
                }
              },
              "on": "http://test.host/concern/works/#{work.id}/manifest/canvas/#{work.id}"
            }
          ]
        }
      ]
    }
  ]
}
HEREDOC
    expect(JSON.parse(rendered)).to eq(JSON.parse(doc))
  end
end
