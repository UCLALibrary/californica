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
end
