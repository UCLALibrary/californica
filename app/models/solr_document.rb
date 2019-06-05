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

  def ark
    self[:ark_ssi]
  end

  def architect
    self[Solrizer.solr_name('architect')]
  end

  def extent
    self[Solrizer.solr_name('extent')]
  end

  def caption
    self[Solrizer.solr_name('caption')]
  end

  def geographic_coordinates
    self[:geographic_coordinates_ssim]
  end

  def dimensions
    self[Solrizer.solr_name('dimensions')]
  end

  def dlcs_collection_name
    self[:dlcs_collection_name_ssm]
  end

  def funding_note
    self[Solrizer.solr_name('funding_note')]
  end

  def genre
    self[Solrizer.solr_name('genre')]
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

  def medium
    self[Solrizer.solr_name('medium')]
  end

  def named_subject
    self[Solrizer.solr_name('named_subject')]
  end

  def normalized_date
    self[Solrizer.solr_name('normalized_date')]
  end

  def photographer
    self[Solrizer.solr_name('photographer')]
  end

  def repository
    self[Solrizer.solr_name('repository')]
  end

  def rights_country
    self[Solrizer.solr_name('rights_country')]
  end

  def rights_holder
    self[Solrizer.solr_name('rights_holder')]
  end

  def services_contact
    self[:services_contact_ssm]
  end
end
