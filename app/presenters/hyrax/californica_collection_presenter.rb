# frozen_string_literal: true
module Hyrax
  class CalifornicaCollectionPresenter < Hyrax::CollectionPresenter
    # Terms is the list of fields displayed by
    # app/views/collections/_show_descriptions.html.erb
    def self.terms
      [
        :alternative_title,
        :architect,
        :ark,
        :artist,
        :author,
        :binding_note,
        :based_near,
        :calligrapher,
        :cartographer,
        :caption,
        :citation_source,
        :collation,
        :colophon,
        :composer,
        :commentator,
        :contributor,
        :condition_note,
        :content_disclaimer,
        :contents_note,
        :creator,
        :date_created,
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
        :iiif_viewing_hint,
        :illustrations_note,
        :illustrator,
        :identifier,
        :identifier_global,
        :illuminator,
        :interviewer,
        :interviewee,
        :keyword,
        :location,
        :language,
        :latitude,
        :license,
        :longitude,
        :local_identifier,
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
        :printer,
        :printmaker,
        :provenance,
        :program,
        :producer,
        :publisher,
        :recipient,
        :related_to,
        :related_url,
        :representative_image,
        :repository,
        :researcher,
        :resp_statement,
        :rights_country,
        :rights_holder,
        # :local_rights_statement, # This invokes License renderer from hyrax gem
        :resource_type,
        :rubricator,
        :scribe,
        :series,
        :services_contact,
        :size,
        :subject,
        :subject_geographic,
        :subject_temporal,
        :subject_cultural_object,
        :subject_domain_topic,
        :subject_topic,
        :support,
        :summary,
        :tagline,
        :thumbnail_link,
        :iiif_text_direction,
        :translator,
        :toc,
        :total_items,
        :uniform_title
      ]
    end
  end
end
