# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::WorkForm do
  let(:form) { described_class.new(Work.new, {}, {}) }

  it 'has all the custom terms' do
    expect(form.terms).to include(:extent, :caption, :dimensions,
                                  :funding_note, :genre, :latitude,
                                  :longitude, :local_identifier, :medium,
                                  :named_subject, :normalized_date, :repository,
                                  :rights_country, :rights_holder, :photographer)
  end
end
