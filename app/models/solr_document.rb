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

  def extent
    self[:extent_tesim]
  end

  def caption
    self[:caption_tesim]
  end

  def geographic_coordinates
    self[:geographic_coordinates_ssim]
  end

  def dimensions
    self[:dimensions_tesim]
  end

  def dlcs_collection_name
    self[:dlcs_collection_name_ssm]
  end

  def funding_note
    self[:funding_note_tesim]
  end

  def genre
    self[:genre_tesim]
  end

  def latitude
    self[Solrizer.solr_name('latitude')]
  end

  def location
    self[Solrizer.solr_name('location')]
  end

  def local_identifier
    self[:local_identifier_ssm]
  end

  def longitude
    self[Solrizer.solr_name('longitude')]
  end

  def master_file_path
    self['master_file_path_ssi']
  end

  def medium
    self[:medium_tesim]
  end

  def named_subject
    self[:named_subject_tesim]
  end

  def normalized_date
    self[:normalized_date_tesim]
  end

  def photographer
    self[:photographer_tesim]
  end

  def place_of_origin
    self[:place_of_origin_tesim]
  end

  def repository
    self[:repository_tesim]
  end

  def rights_country
    self[:rights_country_tesim]
  end

  def rights_holder
    self[:rights_holder_tesim]
  end

  def services_contact
    self[:services_contact_ssm]
  end

  def summary
    self[:summary_tesim]
  end

  def support
    self[:support_tesim]
  end

  def uniform_title
    self[Solrizer.solr_name('uniform_title')]
  end

  # Override this method from hyrax gem to allow
  # Californica to use "discovery" visibility.
  # app/models/concerns/hyrax/solr_document_behavior.rb
  def visibility
    return @visibility if @visibility

    discovery = self[:visibility_ssi] == Work::VISIBILITY_TEXT_VALUE_DISCOVERY &&
                lease_expiration_date.blank? &&
                embargo_release_date.blank?

    @visibility = if discovery
                    Work::VISIBILITY_TEXT_VALUE_DISCOVERY
                  else
                    super
                  end
  end
end
