# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work ChildWork`
require 'rails_helper'

RSpec.describe Hyrax::ChildWorkForm do
  let(:form) { described_class.new(Work.new, {}, {}) }

  it 'has all the custom terms' do
    expect(form.terms).to include(:extent, :architect, :caption, :dimensions,
                                  :funding_note, :genre, :latitude,
                                  :longitude, :local_identifier, :medium,
                                  :named_subject, :normalized_date, :repository,
                                  :rights_country, :rights_holder, :photographer)
  end
end
