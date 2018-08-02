# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
require 'rails_helper'

RSpec.describe Work do
  it "has a genre" do
    work = described_class.new
    work.genre = ["cellulose nitrate film"]
    work.save
    expect(work.genre).to include "cellulose nitrate film"
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/type/)
  end
end
