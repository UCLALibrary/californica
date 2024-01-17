# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  def access_copy
    self['access_copy_ssi']
  end

  def alternative_title
    self[:alternative_title_tesim]
  end

  def author
    self[:author_tesim]
  end

  def ark
    self[:ark_ssi]
  end

  def architect
    self[:architect_tesim]
  end

  def artist
    self[:artist_tesim]
  end

  def binding_note
    self[:binding_note_ssi]
  end

  def calligrapher
    self[:calligrapher_tesim]
  end

  def caption
    self[:caption_tesim]
  end

  def cartographer
    self[:cartographer_tesim]
  end

  def citation_source
    self[:citation_source_tesim]
  end

  def collation
    self[:collation_ssi]
  end

  def colophon
    self[:colophon_tesim]
  end

  def commentator
    self[:commentator_tesim]
  end

  def composer
    self[:composer_tesim]
  end

  def condition_note
    self[:condition_note_ssi]
  end

  def content_disclaimer
    self[:content_disclaimer_ssm]
  end

  def contents_note
    self[:contents_note_tesim]
  end

  def geographic_coordinates
    self[:geographic_coordinates_ssim]
  end

  def dimensions
    self[:dimensions_tesim]
  end

  def director
    self[:director_tesim]
  end

  def dlcs_collection_name
    self[:dlcs_collection_name_ssm]
  end

  def edition
    self[:edition_ssm]
  end

  def editor
    self[:editor_tesim]
  end

  def electronic_locator
    self[:electronic_locator_ss]
  end

  def engraver
    self[:engraver_tesim]
  end

  def extent
    self[:extent_tesim]
  end

  def featured_image
    self[:featured_image_ssi]
  end

  def foliation
    self[:foliation_ssi]
  end

  def format_book
    self[:format_book_tesim]
  end

  def funding_note
    self[:funding_note_tesim]
  end

  def finding_aid_url
    self[:finding_aid_url_ssm]
  end

  def genre
    self[:genre_tesim]
  end

  def history
    self[:history_tesim]
  end

  def host
    self[:host_tesim]
  end

  def human_readable_related_record_title
    self[:human_readable_related_record_title_ssm]
  end

  def iiif_manifest_url
    self[:iiif_manifest_url_ssi] || ""
  end

  def iiif_range
    self[:iiif_range_ssi]
  end

  def iiif_text_direction
    self[:iiif_text_direction_ssi]
  end

  def iiif_viewing_hint
    self[:iiif_viewing_hint_ssi]
  end

  def illuminator
    self[:illuminator_tesim]
  end

  def illustrations_note
    self[:illustrations_note_tesim]
  end

  def illustrator
    self[:illustrator_tesim]
  end

  def interviewee
    self[:interviewee_tesim]
  end

  def interviewer
    self[:interviewer_tesim]
  end

  def latitude
    self[Solrizer.solr_name('latitude')]
  end

  def location
    self[Solrizer.solr_name('location')]
  end

  def local_identifier
    self[:local_identifier_ssim]
  end

  def longitude
    self[Solrizer.solr_name('longitude')]
  end

  def lyricist
    self[:lyricist_tesim]
  end

  def masthead_parameters
    self[:masthead_parameters_ssi]
  end

  def medium
    self[:medium_tesim]
  end

  def musician
    self[:musician_tesim]
  end

  def named_subject
    self[:named_subject_tesim]
  end

  def normalized_date
    self[:normalized_date_tesim]
  end

  def note
    self[:note_tesim]
  end

  def note_admin
    self[:note_admin_tesim]
  end

  def opac_url
    self[:opac_url_ssi]
  end

  def oai_set
    self[:oai_set_ssim]
  end

  def page_layout
    self[:page_layout_ssim]
  end

  def photographer
    self[:photographer_tesim]
  end

  def place_of_origin
    self[:place_of_origin_tesim]
  end

  def printer
    self[:printer_tesim]
  end

  def program
    self[:program_tesim]
  end

  def printmaker
    self[:printmaker_tesim]
  end

  def preservation_copy
    self['preservation_copy_ssi']
  end

  def producer
    self[:producer_tesim]
  end

  def provenance
    self[:provenance_tesim]
  end

  def recipient
    self[:recipient_tesim]
  end

  def related_record
    self[:related_record_ssm]
  end

  def related_to
    self[:related_to_ssm]
  end

  def repository
    self[:repository_tesim]
  end

  def representative_image
    self[:representative_image_ssi]
  end

  def researcher
    self[:researcher_tesim]
  end

  def resp_statement
    self[:resp_statement_tesim]
  end

  def rights_country
    self[:rights_country_tesim]
  end

  def rights_holder
    self[:rights_holder_tesim]
  end

  def rubricator
    self[:rubricator_tesim]
  end

  def local_rights_statement
    self[:local_rights_statement_ssm]
  end

  def scribe
    self[:scribe_tesim]
  end

  def series
    self[:series_tesim]
  end

  def services_contact
    self[:services_contact_ssm]
  end

  def subject_geographic
    self[:subject_geographic_tesim]
  end

  def subject_temporal
    self[:subject_temporal_tesim]
  end

  def subject_cultural_object
    self[:subject_cultural_object_tesim]
  end

  def subject_domain_topic
    self[:subject_domain_topic_tesim]
  end

  def subject_topic
    self[:subject_topic_tesim]
  end

  def summary
    self[:summary_tesim]
  end

  def support
    self[:support_tesim]
  end

  def tagline
    self[:tagline_ssi]
  end

  def thumbnail_link
    self[:thumbnail_link_ssi]
  end

  def thumbnail_url
    self[:thumbnail_url_ss]
  end

  def translator
    self[:translator_tesim]
  end

  def toc
    self[:toc_tesim]
  end

  def uniform_title
    self[Solrizer.solr_name('uniform_title')]
  end

  def archival_collection_title
    self[:archival_collection_title_ssi]
  end

  def archival_collection_number
    self[:archival_collection_number_ssi]
  end

  def archival_collection_box
    self[:archival_collection_box_ssi]
  end

  def archival_collection_folder
    self[:archival_collection_folder_ssi]
  end

  # Override this method from hyrax gem to allow
  # Californica to use "sinai" visibility.
  # app/models/concerns/hyrax/solr_document_behavior.rb
  def visibility
    return @visibility if @visibility

    sinai = self[:visibility_ssi] == Work::VISIBILITY_TEXT_VALUE_SINAI &&
            lease_expiration_date.blank? &&
            embargo_release_date.blank?

    @visibility = if sinai
                    Work::VISIBILITY_TEXT_VALUE_SINAI
                  else
                    super
                  end
  end
end
