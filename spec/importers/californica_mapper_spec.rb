# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaMapper do
  subject(:mapper) { described_class.new }

  let(:metadata) do
    { "Item Ark" => "21198/zz0002nq4w",
      "Title" => "Protesters with signs in gallery of Los Angeles County Supervisors " \
      "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947",
      "Type.typeOfResource" => "still image",
      "Subject" => "Express highways--California--Los Angeles County--Design and construction|~|" \
      "Eminent domain--California--Los Angeles|~|Demonstrations--California--Los Angeles County|~|" \
      "Transportation|~|Government|~|Activism|~|Interstate 10",
      "Publisher.publisherName" => "Los Angeles Daily News",
      "Format.medium" => "1 photograph",
      "Name.repository" => "University of California, Los Angeles. $b Library Special Collections",
      "Description.caption" => "This example does not have a caption.",
      "masterImageName" => "clusc_1_1_00010432a.tif" }
  end

  before { mapper.metadata = metadata }

  it "maps the required title field" do
    expect(mapper.map_field(:title))
      .to contain_exactly("Protesters with signs in gallery of Los Angeles County Supervisors " \
                          "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947")
  end

  it "maps the required identifier field" do
    expect(mapper.map_field(:identifier)).to contain_exactly('21198/zz0002nq4w')
  end

  it "maps remote_files" do
    expect(mapper.remote_files)
      .to contain_exactly(url: match(/clusc_1_1_00010432a\.tif/))
  end

  it "maps visibility to open" do
    expect(mapper.visibility)
      .to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end

  describe '#fields' do
    it 'has expected fields' do
      expect(mapper.fields).to include(
        :visibility, :identifier, :title, :subject,
        :resource_type, :description, :latitude,
        :longitude, :extent, :local_identifier,
        :date_created, :caption, :dimensions,
        :funding_note, :genre, :rights_holder,
        :medium, :normalized_date
      )
    end
  end

  describe '#extent' do
    context 'when collection is LADNN' do
      let(:metadata) do
        { "Project Name" => "Los Angeles Daily News Negatives",
          "Format.extent" => "This value is ignored" }
      end

      it 'hard codes the extent field' do
        expect(mapper.extent).to eq ['1 photograph']
      end
    end

    context 'when it doesn\'t require special handling' do
      let(:metadata) do
        { "Project Name" => "Another collection",
          "Format.extent" => "Ext 1|~|Ext 2" }
      end

      it 'reads the value from the metadata' do
        expect(mapper.extent).to contain_exactly("Ext 1", "Ext 2")
      end
    end
  end

  describe '#repository' do
    context 'when collection is LADNN' do
      let(:metadata) do
        { "Project Name" => "Los Angeles Daily News Negatives",
          "Name.repository" => "This value is ignored" }
      end

      it 'hard codes the repository field' do
        expect(mapper.repository).to eq ['University of California, Los Angeles. Library. Department of Special Collections']
      end
    end

    context 'when it doesn\'t require special handling' do
      let(:metadata) do
        { "Project Name" => "Another collection",
          "Name.repository" => "Repo 1|~|Repo 2" }
      end

      it 'reads the value from the metadata' do
        expect(mapper.repository).to contain_exactly("Repo 1", "Repo 2")
      end
    end
  end
end
