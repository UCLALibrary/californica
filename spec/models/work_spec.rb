# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
require 'rails_helper'

RSpec.describe Work do
  it "has genre" do
    work = described_class.new
    work.genre = ['SciFi']
    expect(work.genre).to include 'SciFi'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/type/)
  end
end
