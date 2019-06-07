# frozen_string_literal: true
require "rails_helper"

RSpec.describe "manifest", type: :view do
  let(:work) { FactoryBot.create(:work) }
  let(:file_set) { FactoryBot.create(:file_set) }
  let(:solr_doc) { SolrDocument.find(work.id) }
  let(:sets) { Californica::ManifestBuilderService.new(curation_concern: work).sets }
  let(:manifest) { File.open(Rails.root.join('spec', 'fixtures', 'manifests', 'manifest.json')) }

  it "displays a valid IIIF Presentation API manifest" do
    assign(:root_url, 'http://localhost:3000/manifest')
    assign(:solr_doc, solr_doc)
    assign(:sets, sets)

    Hydra::Works::UploadFileToFileSet.call(file_set, File.open(Rails.root.join('spec', 'fixtures', 'images', 'good', 'food.tif')))
    work.ordered_members << file_set
    render
    json = JSON.parse(rendered)

    expect(json['label']).to eq work.title.first
    expect(json['description']).to eq work.description.first
    expect(json["@context"]).to eq "http://iiif.io/api/presentation/2/context.json"
    expect(json["@id"]).to eq "http://localhost:3000/manifest"
    expect(json["@type"]).to eq "sc:Manifest"
    expect(json["sequences"][0]["@type"]).to eq "sc:Sequence"
    expect(json["sequences"][0]["canvases"]).not_to be nil
  end
end
