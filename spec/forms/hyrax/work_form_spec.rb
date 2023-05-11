# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::WorkForm do
  let(:form) { described_class.new(Work.new, {}, {}) }

  it 'has all the custom terms' do
    expect(form.terms).to include(
      :access_copy,
      :alternative_title,
      :architect,
      :ark,
      :artist,
      :author,
      :binding_note,
      :calligrapher,
      :caption,
      :cartographer,
      :citation_source,
      :collation,
      :colophon,
      :composer,
      :commentator,
      :condition_note,
      :content_disclaimer,
      :contents_note,
      :contributor,
      :creator,
      :dimensions,
      :director,
      :editor,
      :engraver,
      :extent,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :format_book,
      :funding_note,
      :genre,
      :host,
      :iiif_manifest_url,
      :iiif_range,
      :iiif_text_direction,
      :iiif_viewing_hint,
      :illuminator,
      :illustrations_note,
      :illustrator,
      :interviewer,
      :interviewee,
      :latitude,
      :license,
      :local_identifier,
      :local_rights_statement,
      :location,
      :longitude,
      :lyricist,
      :masthead_parameters,
      :medium,
      :musician,
      :named_subject,
      :normalized_date,
      :note,
      :note_admin,
      :opac_url,
      :page_layout,
      :photographer,
      :place_of_origin,
      :preservation_copy,
      :printer,
      :printmaker,
      :producer,
      :program,
      :provenance,
      :recipient,
      :related_to,
      :repository,
      :representative_image,
      :researcher,
      :resource_type,
      :resp_statement,
      :rights_country,
      :rights_holder,
      :rubricator,
      :scribe,
      :series,
      :subject_cultural_object,
      :subject_domain_topic,
      :subject_geographic,
      :subject_temporal,
      :subject_topic,
      :summary,
      :support,
      :tagline,
      :thumbnail_link,
      :toc,
      :translator,
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
