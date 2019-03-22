# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Collection do
  subject(:collection) { described_class.new }

  describe 'with ARK' do
    let(:ark) { "ark:/#{identifier}" }
    let(:identifier) { 'coll/222' }
    let(:similar_identifier) { 'coll/222111' }

    let(:collection) { FactoryBot.create(:collection, identifier: [identifier]) }
    let(:collection_with_similar_ark) { FactoryBot.create(:collection, identifier: [similar_identifier]) }

    # Clean up any old collections, so we know exactly what we're working with.
    before { described_class.destroy_all }

    describe '::find_by_ark' do
      let(:found) { described_class.find_by_ark(ark) }

      context 'two collections' do
        before do
          # Create the collections
          collection_with_similar_ark
          collection
        end

        it 'finds the correct collection' do
          expect(described_class.count).to eq 2
          expect(found).to eq collection
        end
      end

      context 'a collection with a similar ark' do
        before do
          collection_with_similar_ark # Create it
        end

        it 'doesn\'t return the wrong collection' do
          expect(described_class.count).to eq 1
          expect(found).to eq nil
        end
      end
    end

    describe '::find_or_create_by_ark' do
      let(:result) { described_class.find_or_create_by_ark(ark) }

      context 'when the collection already exists' do
        before { collection } # Create the collection

        it 'doesn\'t create a new collection' do
          expect { result }.to change { described_class.count }.by(0)
          expect(result).to eq collection
        end
      end

      context 'when the collection doesn\'t exist' do
        it 'creates a new collection' do
          expect { result }.to change { described_class.count }.to(1)
          expect(result.title).to eq ["Collection #{ark}"]
          expect(result.identifier).to eq [ark]
          expect(result.edit_groups).to eq ['admin']
        end
      end
    end
  end

  describe '#genre' do
    let(:values) { ['SciFi'] }

    it 'can set a genre' do
      expect { collection.genre = values }
        .to change { collection.genre.to_a }
        .to contain_exactly(*values)
    end

    it 'sets to edm:hasType' do
      expect { collection.genre = values }
        .to change { collection.resource.predicates }
        .to include RDF::Vocab::EDM.hasType
    end
  end

  it "has publisher" do
    collection.publisher = ['publisher']
    expect(collection.publisher).to include 'publisher'
    expect(collection.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/publisher/)
  end

  it "has extent" do
    collection.extent = ['1 photograph']
    expect(collection.extent).to include '1 photograph'
    expect(collection.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/format/)
  end

  it "has repository" do
    collection.repository = ['a repository']
    expect(collection.repository).to include 'a repository'
    expect(collection.resource.dump(:ttl)).to match(/loc.gov\/mods\/rdf\/v1#locationCopySublocation/)
  end

  it "has normalized date" do
    collection.normalized_date = ['01/01/01']
    expect(collection.normalized_date).to include '01/01/01'
    expect(collection.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/date/)
  end

  it "has local_identifier" do
    collection.local_identifier = ['local_identifier']
    expect(collection.local_identifier).to include 'local_identifier'
    expect(collection.resource.dump(:ttl)).to match(/id.loc.gov\/vocabulary\/identifiers\/local/)
  end

  it "has funding_note" do
    collection.funding_note = ['funding_note']
    expect(collection.funding_note).to include 'funding_note'
    expect(collection.resource.dump(:ttl)).to match(/bibfra.me\/vocab\/marc\/fundingInformation/)
  end

  it "has latitude" do
    collection.latitude = ['39']
    expect(collection.latitude).to include '39'
    expect(collection.resource.dump(:ttl)).to match(/w3.org\/2003\/12\/exif\/ns#gpsLatitude/)
  end

  it "has longitude" do
    collection.longitude = ['-94']
    expect(collection.longitude).to include '-94'
    expect(collection.resource.dump(:ttl)).to match(/w3.org\/2003\/12\/exif\/ns#gpsLongitude/)
  end

  it "has named subject" do
    collection.named_subject = ['Person, A']
    expect(collection.named_subject).to include 'Person, A'
    expect(collection.resource.dump(:ttl)).to match(/loc.gov\/mods\/rdf\/v1#subjectName/)
  end

  it "rights country" do
    collection.rights_country = ['rights_country']
    expect(collection.rights_country).to include 'rights_country'
    expect(collection.resource.dump(:ttl)).to match(/ebu.ch\/metadata\/ontologies\/ebucore\/ebucore#rightsType/)
  end

  it "has rights holder" do
    collection.rights_holder = ['rights_holder']
    expect(collection.rights_holder).to include 'rights_holder'
    expect(collection.resource.dump(:ttl)).to match(/ebu.ch\/metadata\/ontologies\/ebucore\/ebucore#hasRightsHolder/)
  end

  it "has medium" do
    collection.medium = ['Capacitance Electronic Disc']
    expect(collection.medium).to include 'Capacitance Electronic Disc'
    expect(collection.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/medium/)
  end

  it "has dimensions" do
    collection.dimensions = ['2x4']
    expect(collection.dimensions).to include '2x4'
    expect(collection.resource.dump(:ttl)).to match(/loc.gov\/mods\/rdf\/v1#physicalExtent/)
  end

  it "has caption" do
    collection.caption = ['a caption']
    expect(collection.caption).to include 'a caption'
    expect(collection.resource.dump(:ttl)).to match(/schema.org\/caption/)
  end

  it "has location" do
    collection.location = ['a location']
    expect(collection.location).to include 'a location'
    expect(collection.resource.dump(:ttl)).to match(/purl.org\/dc\/terms\/coverage/)
  end

  it "has photographer" do
    collection.photographer = ['Ansel Adams']
    expect(collection.photographer).to include 'Ansel Adams'
    expect(collection.resource.dump(:ttl)).to match(/id.loc.gov\/vocabulary\/relators\/pht.html/)
  end
end
