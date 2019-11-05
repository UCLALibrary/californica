# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FileSet do
  subject(:fs) { described_class.new }

  it 'can set sinai-level visibility' do
    fs.visibility = FileSet::VISIBILITY_TEXT_VALUE_SINAI
    expect(fs.visibility).to eq 'sinai'
  end
end
