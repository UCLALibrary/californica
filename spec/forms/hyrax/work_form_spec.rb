# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::WorkForm do
  let(:form) { described_class.new(Work.new, {}, {}) }

  it 'has all the custom terms' do
    expect(form.terms).to include(
      :access_copy,
      :alternative_title,
      :architect,
      :author,
      :binding_note,
      :caption,
      :dimensions,
      :extent,
      :funding_note,
      :genre,
      :latitude,
      :local_identifier,
      :longitude,
      :medium,
      :named_subject,
      :normalized_date,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :repository,
      :rights_country,
      :rights_holder,
      :summary,
      :support,
      :iiif_text_direction,
      :uniform_title
    )
  end

  it 'doesn\'t have built-in terms we don\'t want' do
    expect(form.terms).not_to include(:based_near)
  end

  it 'has the right terms above the fold' do
    expect(form.primary_terms).to eq [
      :title,
      :ark,
      :rights_statement,
      :access_copy,
      :preservation_copy
    ]
  end
end
