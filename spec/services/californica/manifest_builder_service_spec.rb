# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Californica::ManifestBuilderService do
  let(:parent_access_copy) { 'parent/image.tif' }
  let(:child_access_copy_1) { 'child/image_1.tif' }
  let(:child_access_copy_2) { 'child/image_2.tif' }
  let(:child_work1) { FactoryBot.create(:child_work, access_copy: child_access_copy_1) }
  let(:child_work2) { FactoryBot.create(:child_work, access_copy: child_access_copy_2) }
  let(:iiif_manifest_url) { manifest_store_url + CGI.escape(work.ark) + '/manifest' }
  let(:manifest_store_url) { 'https://manifest.store.url/' }
  let(:work) do
    w = FactoryBot.create(:work)
    w.ordered_members << child_work1
    w.ordered_members << child_work2
    w
  end
  let(:service) { described_class.new(curation_concern: work) }

  describe '#filesystem_cache_key' do
    it 'combines date modified and id' do
      allow(work).to receive(:date_modified).and_return(DateTime.new(1980, 9, 21, 12, 5, 0, '+00:00'))
      allow(work).to receive(:id).and_return('abc123')
      expect(service.filesystem_cache_key).to eq '1980-09-21_12-05-00abc123'
    end

    context 'when there is no date modified' do
      it 'just uses the id' do
        allow(work).to receive(:date_modified).and_return(nil)
        allow(work).to receive(:id).and_return('abc123')
        expect(service.filesystem_cache_key).to eq 'abc123'
      end
    end

    context 'when there is no id' do
      it 'raises an error' do
        allow(work).to receive(:id).and_return(nil)
        expect { service.filesystem_cache_key }.to raise_error('Cannot persist a IIIF manifest without an object ID. Did you forget to save this object?')
      end
    end
  end

  describe '#iiif_url' do
    let(:work) { FactoryBot.create(:work, access_copy: parent_access_copy) }

    context 'when called with a FileSet' do
      let(:work) { FactoryBot.create(:file_set) }

      it 'returns nil' do
        expect(service.iiif_url).to be_nil
      end
    end

    context 'when access_copy starts with \'http://\'' do
      let(:parent_access_copy) { 'http://iiif.library.ucla.edu/iiif/2/finaltest1' }

      it 'uses the link as is' do
        expect(service.iiif_url).to eq 'http://iiif.library.ucla.edu/iiif/2/finaltest1'
      end
    end

    context 'when access_copy starts with \'https://\'' do
      let(:parent_access_copy) { 'https://iiif.library.ucla.edu/iiif/2/finaltest1' }

      it 'uses the link as is' do
        expect(service.iiif_url).to eq 'https://iiif.library.ucla.edu/iiif/2/finaltest1'
      end
    end

    context 'when access_copy starts with \'Masters/\'' do
      let(:parent_access_copy) { 'Masters/dlmasters/finaltest1' }

      it 'creates a link to the old cantaloupe' do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('IIIF_SERVER_URL').and_return('https://old.cantaloupe.url/iiif/2/')
        expect(service.iiif_url).to eq 'https://old.cantaloupe.url/iiif/2/Masters%2Fdlmasters%2Ffinaltest1'
      end
    end

    context 'when access_copy starts with \'ark:/\'' do
      let(:parent_access_copy) { 'ark:/123/456' }

      it 'creates a link to the new cantaloupe' do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('IIIF_SERVICE_URL').and_return('https://new.cantaloupe.url/iiif/2/')
        expect(service.iiif_url).to eq 'https://new.cantaloupe.url/iiif/2/ark%3A%2F123%2F456'
      end
    end

    context 'when access_copy is nil' do
      let(:parent_access_copy) { nil }

      it 'returns nil' do
        expect(service.iiif_url).to eq nil
      end
    end
  end

  describe '#image_concerns' do
    context 'when the work has children' do
      it 'returns a list of those members' do
        expect(service.image_concerns).to eq [child_work1, child_work2]
      end

      it 'does not include the work, even if it has an access_copy' do
        expect(service.image_concerns).not_to include(work)
      end
    end

    context 'When the parent work has no children' do
      let(:work) { FactoryBot.create(:work, access_copy: parent_access_copy) }

      it 'returns only the parent' do
        expect(service.image_concerns).to eq [work]
      end
    end

    context 'When a child work has no access_copy' do
      let(:child_access_copy_1) { nil }

      it 'gets included anyway' do
        expect(service.image_concerns).to include(child_work1)
      end
    end
  end

  describe '#persist' do
    let(:buffer) { StringIO.new }
    let(:key) { 'abc123' }
    let(:content) { 'Manifest content here!' }

    before do
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:open).with(Rails.root.join('tmp', key), 'w+').and_yield(buffer)
      allow(service).to receive(:filesystem_cache_key).and_return(key)
      allow(service).to receive(:render).and_return(content)
    end

    it 'saves the manifest to the filesystem' do
      service.persist
      expect(buffer.string).to eq(content)
    end

    context 'When ENV[\'IIIF_MANIFEST_URL\'] exists' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('IIIF_MANIFEST_URL').and_return(manifest_store_url)
      end

      it 'saves the manifest to the filesystem' do
        stub_request(:put, iiif_manifest_url).to_return(status: 200)
        service.persist
        expect(buffer.string).to eq(content)
      end

      it 'submits the manifest to the external service' do
        stub = stub_request(:put, iiif_manifest_url).to_return(status: 200)
        service.persist
        expect(stub).to have_been_requested
      end

      it 'populates \'iiif_manifest_url\' if the request to the service succeeded' do
        stub_request(:put, iiif_manifest_url).to_return(status: 200)
        service.persist
        expect(work.iiif_manifest_url).to eq iiif_manifest_url
      end
    end
  end

  describe '#render' do
    let(:expected_result) do
      <<~HEREDOC
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
                "@id": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(child_work1.ark)}",
                "@type": "sc:Canvas",
                "label": "#{child_work1.title.first}",
                "description": "#{child_work1.description.first}",
                "width": 640,
                "height": 480,
                "images": [
                  {
                    "@type": "oa:Annotation",
                    "motivation": "sc:painting",
                    "resource": {
                      "@type": "dctypes:Image",
                      "@id": "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(child_access_copy_1)}/full/600,/0/default.jpg",
                      "width": 640,
                      "height": 480,
                      "service": {
                        "@context": "http://iiif.io/api/image/2/context.json",
                        "@id": "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(child_access_copy_1)}",
                        "profile": "http://iiif.io/api/image/2/level2.json"
                      }
                    },
                    "on": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(child_work1.ark)}"
                  }
                ]
              },
              {
                "@id": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(child_work2.ark)}",
                "@type": "sc:Canvas",
                "label": "#{child_work2.title.first}",
                "description": "#{child_work2.description.first}",
                "width": 640,
                "height": 480,
                "images": [
                  {
                    "@type": "oa:Annotation",
                    "motivation": "sc:painting",
                    "resource": {
                      "@type": "dctypes:Image",
                      "@id": "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(child_access_copy_2)}/full/600,/0/default.jpg",
                      "width": 640,
                      "height": 480,
                      "service": {
                        "@context": "http://iiif.io/api/image/2/context.json",
                        "@id": "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(child_access_copy_2)}",
                        "profile": "http://iiif.io/api/image/2/level2.json"
                      }
                    },
                    "on": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(child_work2.ark)}"
                  }
                ]
              }
            ]
          }
        ]
      }
      HEREDOC
    end

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('RAILS_HOST').and_return('my.url')
    end

    it "displays a valid IIIF Presentation API manifest", aggregate_failures: true do
      expect(JSON.parse(service.render)).to match(JSON.parse(expected_result))
    end
  end

  describe '#root_url' do
    context 'When ENV[\'IIIF_MANIFEST_URL\'] is not set' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('IIIF_MANIFEST_URL').and_return(nil)
      end

      it 'uses ENV[\'RAILS_HOST\']' do
        allow(ENV).to receive(:[]).with('RAILS_HOST').and_return('my.url')
        expect(service.root_url).to eq "http://my.url/concern/works/#{work.id}/manifest"
      end

      it 'defaults to use localhost' do
        allow(ENV).to receive(:[]).with('RAILS_HOST').and_return(nil)
        expect(service.root_url).to eq "http://localhost/concern/works/#{work.id}/manifest"
      end
    end

    context 'When ENV[\'IIIF_MANIFEST_URL\'] exists' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('IIIF_MANIFEST_URL').and_return(manifest_store_url)
      end

      it 'points to the IIIF service, and uses the ark as identifier' do
        expect(service.root_url).to eq manifest_store_url + CGI.escape(work.ark) + '/manifest'
      end
    end
  end
end
