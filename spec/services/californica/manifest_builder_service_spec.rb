# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Californica::ManifestBuilderService do
  let(:parent_access_copy) { 'parent/image.tif' }
  let(:child_access_copy_1) { 'child/image_1.tif' }
  let(:child_access_copy_2) { 'child/image_2.tif' }
  let(:child_work1) { FactoryBot.create(:child_work, access_copy: child_access_copy_1) }
  let(:child_work2) { FactoryBot.create(:child_work, access_copy: child_access_copy_2) }
  let(:work) do
    w = FactoryBot.create(:work, access_copy: parent_access_copy)
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
    it 'returns the set of works needed to create a manifest' do
      expect(service.image_concerns).to eq [work, child_work1, child_work2]
    end

    context 'When the parent work has no access_copy' do
      let(:parent_access_copy) { nil }

      it 'returns the set of child works' do
        expect(service.image_concerns).to eq [child_work1, child_work2]
      end
    end

    context 'When the parent work has no children' do
      let(:work) { FactoryBot.create(:work, access_copy: parent_access_copy) }

      it 'returns only the parent' do
        expect(service.image_concerns).to eq [work]
      end
    end

    context 'When the parent work has neither access_copy nor children' do
      let(:work) { FactoryBot.create(:work, access_copy: nil) }

      it 'returns nothing' do
        expect(service.image_concerns).to eq []
      end
    end

    context 'When the a child work has no access_copy' do
      let(:child_access_copy_1) { nil }

      it 'does not include the child' do
        expect(service.image_concerns).to eq [work, child_work2]
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

    it 'saves the manifest' do
      service.persist
      expect(buffer.string).to eq(content)
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
                "@id": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(work.ark)}",
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
                      "@id": "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(parent_access_copy)}/full/600,/0/default.jpg",
                      "width": 640,
                      "height": 480,
                      "service": {
                        "@context": "http://iiif.io/api/image/2/context.json",
                        "@id": "#{ENV['IIIF_SERVER_URL']}#{CGI.escape(parent_access_copy)}",
                        "profile": "http://iiif.io/api/image/2/level2.json"
                      }
                    },
                    "on": "http://my.url/concern/works/#{work.id}/manifest/canvas/#{CGI.escape(work.ark)}"
                  }
                ]
              },
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
    it 'uses ENV[\'RAILS_HOST\']' do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('RAILS_HOST').and_return('my.url')
      expect(service.root_url).to eq "http://my.url/concern/works/#{work.id}/manifest"
    end

    it 'defaults to use localhost' do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('RAILS_HOST').and_return(nil)
      expect(service.root_url).to eq "http://localhost/concern/works/#{work.id}/manifest"
    end
  end
end
