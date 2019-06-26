# frozen_string_literal: true
require "rails_helper"
require 'cgi'

RSpec.describe "manifest", type: :view do
  let(:work) { FactoryBot.create(:work) }
  let(:file_set) { FactoryBot.create(:file_set) }
  let(:solr_doc) { SolrDocument.find(work.id) }
  let(:sets) { Californica::ManifestBuilderService.new(curation_concern: work).sets }
  let(:manifest) { File.open(Rails.root.join('spec', 'fixtures', 'manifests', 'manifest.json')) }

  before do
    Hydra::Works::UploadFileToFileSet.call(file_set, File.open(Rails.root.join('spec', 'fixtures', 'images', 'good', 'food.tif')))
    work.ordered_members << file_set
    work.save
    assign(:root_url, 'http://localhost:3000/manifest')
    assign(:solr_doc, solr_doc)
    assign(:sets, sets)
  end

  it "displays a valid IIIF Presentation API manifest" do
    render
    file_id = CGI.escape(work.file_sets.first.original_file.id)
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
          "@id": "http://localhost:3000/manifest/canvas/#{work.file_sets.first.id}",
          "@type": "sc:Canvas",
          "label": null,
          "description": null,
          "width": 640,
          "height": 480,
          "images": [
            {
              "@type": "oa:Annotation",
              "motivation": "sc:painting",
              "resource": {
                "@type": "dctypes:Image",
                "@id": "http://test.host/images/#{file_id}/full/600,/0/default.jpg",
                "width": 640,
                "height": 480,
                "service": {
                  "@context": "http://iiif.io/api/image/2/context.json",
                  "@id": "http://test.host/images/#{file_id}",
                  "profile": "http://iiif.io/api/image/2/level2.json"
                }
              },
              "on": "http://test.host/concern/works/#{work.id}/manifest/canvas/#{work.file_sets.first.id}"
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
