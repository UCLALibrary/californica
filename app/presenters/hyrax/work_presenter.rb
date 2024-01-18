# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    delegate(
      :access_copy,
      :alternative_title,
      :architect,
      :archival_collection_title,
      :archival_collection_number,
      :archival_collection_box,
      :archival_collection_folder,
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
      :iiif_manifest_url,
      :iiif_range,
      :illustrations_note,
      :illustrator,
      :iiif_viewing_hint,
      :illuminator,
      :interviewer,
      :interviewee,
      :license,
      :local_identifier,
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
      :human_readable_related_record_title,
      :related_to,
      :repository,
      :representative_image,
      :researcher,
      :resource_type,
      :resp_statement,
      :rights_country,
      :rights_holder,
      :rubricator,
      :local_rights_statement,
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
      :translator,
      :toc,
      :iiif_text_direction,
      :uniform_title,
      to: :solr_document
    )
  end
end
