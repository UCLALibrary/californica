# frozen_string_literal: true
require "rails_helper"
require 'cgi'

RSpec.describe "manifest", type: :view do
  let(:tif) { File.open(Rails.root.join('spec', 'fixtures', 'images', 'good', 'food.tif')) }
  let(:work) { FactoryBot.create(:work, child_work: child_work) }
  let(:child_work) { FactoryBot.create(:work, tif: tif) }
  let(:solr_doc) { SolrDocument.find(work.id) }
  let(:sets) { Californica::ManifestBuilderService.new(curation_concern: work).sets }

  before do
    assign(:root_url, 'http://localhost:3000/manifest')
    assign(:solr_doc, solr_doc)
    assign(:sets, sets)
  end

  it "displays manifest for a work with child works" do
    render
    file_id = CGI.escape(work.ordered_members.to_a.first.file_sets.first.original_file.id)
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
          "@id": "http://localhost:3000/manifest/canvas/#{work.ordered_members.to_a.first.id}",
          "@type": "sc:Canvas",
          "label": "#{work.ordered_members.to_a.first.title.first}",
          "description": "#{work.ordered_members.to_a.first.description.first}",
          "width": 640,
          "height": 480,
          "images": [
            {
              "@type": "oa:Annotation",
              "motivation": "sc:painting",
              "resource": {
                "@type": "dctypes:Image",
                "@id": "#{ENV['IIIF_SERVER_URL']}#{file_id}/full/600,/0/default.jpg",
                "width": 640,
                "height": 480,
                "service": {
                  "@context": "http://iiif.io/api/image/2/context.json",
                  "@id": "#{ENV['IIIF_SERVER_URL']}#{file_id}",
                  "profile": "http://iiif.io/api/image/2/level2.json"
                }
              },
              "on": "http://test.host/concern/works/#{work.id}/manifest/canvas/#{work.ordered_members.to_a.first.id}"
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
