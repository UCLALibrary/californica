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
