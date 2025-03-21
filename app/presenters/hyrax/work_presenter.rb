# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # rubocop:disable Metrics/ClassLength
  class WorkPresenter < Hyrax::WorkShowPresenter
    delegate(
      :access_copy,
      :alternative_title,
      :architect,
      :archival_collection_box,
      :archival_collection_folder,
      :archival_collection_number,
      :archival_collection_title,
      :ark,
      :arranger,
      :artist,
      :author,
      :binding_note,
      :calligrapher,
      :caption,
      :cartographer,
      :citation_source,
      :collation,
      :collector,
      :colophon,
      :commentator,
      :composer,
      :condition_note,
      :content_disclaimer,
      :contents_note,
      :dimensions,
      :director,
      :dlcs_collection_name,
      :edition,
      :editor,
      :electronic_locator,
      :engraver,
      :extent,
      :featured_image,
      :finding_aid_url,
      :foliation,
      :format_book,
      :funding_note,
      :genre,
      :geographic_coordinates,
      :history,
      :host,
      :human_readable_related_record_title,
      :iiif_manifest_url,
      :iiif_range,
      :iiif_text_direction,
      :iiif_viewing_hint,
      :illuminator,
      :illustrations_note,
      :illustrator,
      :inscription,
      :interviewee,
      :interviewer,
      :librettist,
      :license,
      :local_identifier,
      :local_rights_statement,
      :location,
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
      :related_record,
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
      :script,
      :series,
      :services_contact,
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
      :uniform_title,
      to: :solr_document
    )
  end
end
