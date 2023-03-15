# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work ChildWork`
require 'rails_helper'

RSpec.describe Hyrax::ChildWorkForm do
  let(:form) { described_class.new(Work.new, {}, {}) }

  it 'has all the custom terms' do
    expect(form.terms).to include(
      :access_copy,
      :architect,
      :caption,
      :citation_source,
      :commentator,
      :dimensions,
      :extent,
      :format_book,
      :funding_note,
      :genre,
      :host,
      :latitude,
      :local_identifier,
      :longitude,
      :medium,
      :musician,
      :named_subject,
      :normalized_date,
      :note_admin,
      :photographer,
      :preservation_copy,
      :printer,
      :repository,
      :researcher,
      :resp_statement,
      :rights_country,
      :rights_holder,
      :series,
      :subject_temporal,
      :subject_cultural_object,
      :subject_domain_topic,
      :translator
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
      :preservation_copy,
      :thumbnail_link
    ]
  end
end
