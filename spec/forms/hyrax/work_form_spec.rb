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
      :calligrapher,
      :caption,
      :commentator,
      :collation,
      :colophon,
      :composer,
      :condition_note,
      :contents_note,
      :creator,
      :dimensions,
      :editor,
      :engraver,
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
      :illustrator,
      :latitude,
      :license,
      :local_identifier,
      :longitude,
      :lyricist,
      :masthead_parameters,
      :medium,
      :named_subject,
      :normalized_date,
      :note,
      :opac_url,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :printmaker,
      :program,
      :provenance,
      :repository,
      :representative_image,
      :rights_country,
      :rights_holder,
      :rubricator,
      # :local_rights_statement, # This invokes License renderer from hyrax gem
      :scribe,
      :series,
      :subject_topic,
      :subject_geographic,
      :subject_temporal,
      :subject_cultural_object,
      :subject_domain_topic,
      :summary,
      :support,
      :tagline,
      :thumbnail_link,
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
      :preservation_copy,
      :thumbnail_link
    ]
  end
end
