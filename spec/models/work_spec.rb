# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Work do
  it "has extent" do
    work = described_class.new
    work.extent = ['1 photograph']
    expect(work.extent).to include '1 photograph'
    expect(work.resource.dump(:ttl)).to match(/purl.org\/dc\/elements\/1.1\/format/)
  end
end
