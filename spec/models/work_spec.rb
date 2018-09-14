# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Work do
  subject(:work) { described_class.new }

  describe '#genre' do
    let(:values) { ['SciFi'] }

    it 'can set a genre' do
      expect { work.genre = values }
        .to change { work.genre.to_a }
        .to contain_exactly(*values)
    end

    it 'sets to edm:hasType' do
      expect { work.genre = values }
        .to change { work.resource.predicates }
        .to include RDF::Vocab::EDM.hasType
    end
  end

  it "has extent" do
    work.extent = ['1 photograph']
    expect(work.extent).to include '1 photograph'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/format/)
  end

  it "has repository" do
    work.repository = ['a repository']
    expect(work.repository).to include 'a repository'
    expect(work.resource.dump(:ttl)).to match(/loc.gov\/mods\/rdf\/v1#locationCopySublocation/)
  end

  it "has normalized date" do
    work.normalized_date = ['01/01/01']
    expect(work.normalized_date).to include '01/01/01'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/date/)
  end

  it "has local_identifier" do
    work.local_identifier = ['local_identifier']
    expect(work.local_identifier).to include 'local_identifier'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/identifier/)
  end

  it "has funding_note" do
    work.funding_note = ['funding_note']
    expect(work.funding_note).to include 'funding_note'
    expect(work.resource.dump(:ttl)).to match(/bibfra.me\/vocab\/marc\/fundingInformation/)
  end

  it "has latitude" do
    work.latitude = ['39']
    expect(work.latitude).to include '39'
    expect(work.resource.dump(:ttl)).to match(/w3.org\/2003\/12\/exif\/ns#gpsLatitude/)
  end

  it "has longitude" do
    work.longitude = ['-94']
    expect(work.longitude).to include '-94'
    expect(work.resource.dump(:ttl)).to match(/w3.org\/2003\/12\/exif\/ns#gpsLongitude/)
  end

  it "has named subject" do
    work.named_subject = ['Person, A']
    expect(work.named_subject).to include 'Person, A'
    expect(work.resource.dump(:ttl)).to match(/loc.gov\/mods\/rdf\/v1#subjectName/)
  end
end
