# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
class WorkIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc['sort_year_isi'] = years.to_a.min
      solr_doc['geographic_coordinates_ssim'] = coordinates
      solr_doc['human_readable_language_sim'] = human_readable_language
      solr_doc['human_readable_language_tesim'] = human_readable_language
      solr_doc['human_readable_resource_type_sim'] = human_readable_resource_type
      solr_doc['human_readable_resource_type_tesim'] = human_readable_resource_type
      solr_doc['human_readable_rights_statement_tesim'] = human_readable_rights_statement
      solr_doc['sort_title_tesi'] = object.title.first
      solr_doc['ursus_id_ssi'] = Californica::IdGenerator.blacklight_id_from_ark(object.ark)
      solr_doc['year_isim'] = years
    end
  end

  def coordinates
    return unless object.latitude.first && object.longitude.first
    [object.latitude.first, object.longitude.first].join(', ')
  end

  def human_readable_language
    rights_terms = Qa::Authorities::Local.subauthority_for('languages').all

    object.language.map do |lang|
      term = rights_terms.find { |entry| entry[:id] == lang }
      term.blank? ? lang : term[:label]
    end
  end

  def human_readable_resource_type
    rights_terms = Qa::Authorities::Local.subauthority_for('resource_types').all

    object.resource_type.map do |rt|
      term = rights_terms.find { |entry| entry[:id] == rt }
      term.blank? ? rt : term[:label]
    end
  end

  def human_readable_rights_statement
    rights_terms = Qa::Authorities::Local.subauthority_for('rights_statements').all

    object.rights_statement.map do |rs|
      term = rights_terms.find { |entry| entry[:id] == rs }
      term.blank? ? rs : term[:label]
    end
  end

  # The 'to_a' is needed to force ActiveTriples::Relation to resolve into the String value(s), else you get an error trying to parse the date.
  def years
    integer_years = YearParser.integer_years(object.normalized_date.to_a)
    return nil if integer_years.blank?
    integer_years
  end
end
