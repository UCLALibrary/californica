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
      :archival_collection_box,
      :archival_collection_folder,
      :archival_collection_number,
      :archival_collection_title,
      :arranger,
      :caption,
      :citation_source,
      :collector,
      :commentator,
      :dimensions,
      :edition,
      :electronic_locator,
      :extent,
      :format_book,
      :funding_note,
      :genre,
      :history,
      :host,
      :identifier,
      :inscription,
      :latitude,
      :librettist,
      :local_identifier,
      :local_rights_statement,
      :longitude,
      :medium,
      :musician,
      :named_subject,
      :normalized_date,
      :note_admin,
      :photographer,
      :preservation_copy,
      :printer,
      :related_record,
      :related_to,
      :repository,
      :researcher,
      :resp_statement,
      :rights_country,
      :rights_holder,
      :script,
      :series,
      :subject_cultural_object,
      :subject_domain_topic,
      :subject_temporal,
      :translator,
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
