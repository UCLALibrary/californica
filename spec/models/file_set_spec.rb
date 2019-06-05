# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FileSet do
  subject(:fs) { described_class.new }

  it 'can set discovery-level visibility' do
    fs.visibility = FileSet::VISIBILITY_TEXT_VALUE_DISCOVERY
    expect(fs.visibility).to eq 'discovery'
  end
end
