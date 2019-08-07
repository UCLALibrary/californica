# frozen_string_literal: true
require "rails_helper"
require 'cgi'

RSpec.describe "manifest", type: :view do
  let(:access_copy) { 'a/b/c.tif' }
  let(:work) { FactoryBot.create(:work, child_work: child_work) }
  let(:child_work) { FactoryBot.create(:work, access_copy: access_copy) }
  let(:solr_doc) { SolrDocument.find(work.id) }
  let(:builder_service) { Californica::ManifestBuilderService.new(curation_concern: work) }
  let(:image_concerns) { builder_service.image_concerns }
  let(:root_url) { builder_service.root_url }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('RAILS_HOST').and_return('my.url')

    assign(:root_url, root_url)
    assign(:solr_doc, solr_doc)
    assign(:image_concerns, image_concerns)
  end

  it "displays manifest for a work with child works" do
    render
    iiif_id = CGI.escape(access_copy)
    doc = <<~HEREDOC
{
  "@context": "http://iiif.io/api/presentation/2/context.json",
  "@type": "sc:Manifest",
  "@id": "http://my.url/concern/works/#{work.id}/manifest",
  "label": "#{work.title.first}",
  "description": "#{work.description.first}",
  "sequences": [
    {
      "@type": "sc:Sequence",
      "@id": "http://my.url/concern/works/#{work.id}/manifest/sequence/normal",
      "canvases": [
        {
          "@id": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(child_work.ark)}",
          "@type": "sc:Canvas",
          "label": "#{child_work.title.first}",
          "description": "#{child_work.description.first}",
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
              "on": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(child_work.ark)}"
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
