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
      "Name.repository" => "University of California, Los Angeles. $b Library Special Collections" }
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

  it "maps visibility to open" do
    expect(mapper.visibility)
      .to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end

  describe '#fields' do
    it 'has expected fields' do
      expect(mapper.fields).to include(:visibility, :identifier, :title, :subject, :description)
    end
  end
end
