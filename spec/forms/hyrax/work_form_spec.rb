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
      :commentator,
      :collation,
      :colophon,
      :composer,
      :condition_note,
      :creator,
      :dimensions,
      :extent,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :funding_note,
      :genre,
      :iiif_manifest_url,
      :iiif_viewing_hint,
      :iiif_range,
      :illuminator,
      :illustrations_note,
      :latitude,
      :local_identifier,
      :longitude,
      :lyricist,
      :masthead_parameters,
      :medium,
      :named_subject,
      :normalized_date,
      :opac_url,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :provenance,
      :repository,
      :representative_image,
      :rights_country,
      :rights_holder,
      :rubricator,
      # :local_rights_statement, # This invokes License renderer from hyrax gem
      :scribe,
      :subject_topic,
      :subject_geographic,
      :subject_temporal,
      :summary,
      :support,
      :tagline,
      :toc,
      :translator,
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
