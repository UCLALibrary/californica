# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work ChildWork`
require 'rails_helper'

RSpec.describe ChildWork do
  subject(:work) { described_class.new }
  it_behaves_like 'a work with UCLA metadata'

  it 'can set sinai-level visibility' do
    work.visibility = FileSet::VISIBILITY_TEXT_VALUE_SINAI
    expect(work.visibility).to eq 'sinai'
  end
end
