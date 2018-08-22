# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaMapper do
  subject(:mapper) { described_class.new }

  let(:hyrax_metadata) do
    { identifier: ["21198/zz0002nq4w"],
      title: ["Protesters with signs in gallery of Los Angeles County Supervisors " \
      "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947"],
      type: "still image",
      subject: "Express highways--California--Los Angeles County--Design and construction|~|" \
      "Eminent domain--California--Los Angeles|~|Demonstrations--California--Los Angeles County|~|" \
      "Transportation|~|Government|~|Activism|~|Interstate 10",
      publisher_name: "Los Angeles Daily News",
      medium: "1 photograph",
      repository_name: "University of California, Los Angeles. $b Library Special Collections" }
  end

  it "maps the required title field" do
    mapper.metadata = { "Title" => "Protesters with signs in gallery of Los Angeles County Supervisors " \
      "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947" }
    expect(mapper.map_field(:title)).to eq(["Protesters with signs in gallery of Los Angeles County Supervisors " \
    "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947"])
  end

  it "maps the required identifier field" do
    mapper.metadata = { "Item Ark" => "21198/zz0002nq4w" }
    expect(mapper.map_field(:identifier)).to eq(["21198/zz0002nq4w"])
  end
end
