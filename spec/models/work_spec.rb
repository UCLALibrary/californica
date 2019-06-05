
# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Work do
  subject(:work) { described_class.new }
  it_behaves_like 'a work with UCLA metadata'

  it 'can set discovery-level visibility' do
    work.visibility = Work::VISIBILITY_TEXT_VALUE_DISCOVERY
    expect(work.visibility).to eq 'discovery'
  end
end
