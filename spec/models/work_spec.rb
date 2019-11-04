
# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Work do
  subject(:work) { described_class.new }
  it_behaves_like 'a work with UCLA metadata'

  it 'can set sinai-level visibility' do
    work.visibility = Work::VISIBILITY_TEXT_VALUE_SINAI
    expect(work.visibility).to eq 'sinai'
  end
end
