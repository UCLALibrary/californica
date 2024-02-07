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

  # See https://github.com/UCLALibrary/californica/blob/main/solr/config/schema.xml#194
  # for extensions that can be used below

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc['combined_subject_ssim'] = combined_subject
      add_dates(solr_doc)
      solr_doc['geographic_coordinates_ssim'] = coordinates
      solr_doc['human_readable_iiif_text_direction_ssi'] = human_readable_iiif_text_direction
      solr_doc['human_readable_iiif_viewing_hint_ssi'] = human_readable_iiif_viewing_hint
      solr_doc['human_readable_language_sim'] = human_readable_language
      solr_doc['human_readable_language_tesim'] = human_readable_language
      solr_doc['human_readable_resource_type_sim'] = human_readable_resource_type
      solr_doc['human_readable_resource_type_tesim'] = human_readable_resource_type
      solr_doc['human_readable_rights_statement_tesim'] = human_readable_rights_statement
      solr_doc['sort_year_isi'] = years.to_a.min
      solr_doc['thumbnail_url_ss'] = thumbnail_url
      solr_doc['title_alpha_numeric_ssort'] = object.title.first
      solr_doc['ursus_id_ssi'] = Californica::IdGenerator.blacklight_id_from_ark(object.ark)
      solr_doc['year_isim'] = years
      solr_doc['human_readable_related_record_title_ssm'] = find_related_records_titles_by_ark
      solr_doc['archival_collection_tesi'] = archival_collection
    end
  end

  # https://github.com/samvera/hyrax/blob/c728f537d1ccca9762a3f01e9f30a55983e8820d/app/indexers/hyrax/work_indexer.rb#L11
  def find_related_records_titles_by_ark
    if object.related_record
      ark_titles = []
      object.related_record.each do |ark_string|
        # Assuming you want to call find_by_ark on each ark_string
        result = Work.find_by_ark(ark_string)
        if result
          ursus_url = ::Ursus::Record.url_for_ark(result)
          ark_titles.push("<a href='#{ursus_url}'>#{result.title.first}</a>")
        end
      end
      ark_titles
    end
  end

  def related_record_title_markup(ursus_url, title)
    title_markup = '<a href="' + ursus_url + '">' + title + '</a>'
    title_markup
  end

  def add_dates(solr_doc)
    valid_dates = solr_dates
    solr_doc['date_dtsim'] = valid_dates if valid_dates
    solr_doc['date_dtsort'] = solr_doc['date_dtsim'][0] if solr_doc['date_dtsort']
  end

  def combined_subject
    object.named_subject.to_a + object.subject.to_a + object.subject_topic.to_a + object.subject_geographic.to_a + object.subject_temporal.to_a
  end

  def coordinates
    return unless object.latitude.first && object.longitude.first
    [object.latitude.first, object.longitude.first].join(', ')
  end

  def human_readable_language
    terms = Qa::Authorities::Local.subauthority_for('languages').all

    object.language.map do |lang|
      term = terms.find { |entry| entry[:id] == lang }
      term.blank? ? lang : term[:label]
    end
  end

  def human_readable_resource_type
    terms = Qa::Authorities::Local.subauthority_for('resource_types').all

    object.resource_type.map do |rt|
      term = terms.find { |entry| entry[:id] == rt }
      term.blank? ? rt : term[:label]
    end
  end

  def human_readable_iiif_text_direction
    terms = Qa::Authorities::Local.subauthority_for('iiif_text_directions').all
    term = terms.find { |entry| entry[:id] == object.iiif_text_direction }
    term.blank? ? object.iiif_text_direction : term[:label]
  end

  def human_readable_iiif_viewing_hint
    terms = Qa::Authorities::Local.subauthority_for('iiif_viewing_hints').all
    term = terms.find { |entry| entry[:id] == object.iiif_viewing_hint }
    term.blank? ? object.iiif_viewing_hint : term[:label]
  end

  def human_readable_rights_statement
    terms = Qa::Authorities::Local.subauthority_for('rights_statements').all

    object.rights_statement.map do |rs|
      term = terms.find { |entry| entry[:id] == rs }
      term.blank? ? rs : term[:label]
    end
  end

  def thumbnail_url
    thumbnail = object.thumbnail_link || thumbnail_from_access_copy
    case thumbnail
    when /\.(svg)|(png)|(jpg)$/
      thumbnail
    when /\/iiif\/2\/[^\/]+$/
      "#{thumbnail}/full/!200,200/0/default.jpg"
    else
      return nil
    end
  end

  def thumbnail_from_access_copy
    # this record has an image path attached
    iiif_resource = Californica::ManifestBuilderService.new(curation_concern: object).iiif_url
    children = Array.wrap(object.members).clone
    until iiif_resource || children.empty?
      child = children.shift
      iiif_resource = Californica::ManifestBuilderService.new(curation_concern: child).iiif_url
    end
    iiif_resource
  end

  # The 'to_a' is needed to force ActiveTriples::Relation to resolve into the String value(s), else you get an error trying to parse the date.
  def years
    integer_years = YearParser.integer_years(object.normalized_date.to_a).select { |year| year >= 0 }
    return nil if integer_years.blank?
    integer_years
  end

  def solr_dates
    dates = object.normalized_date.to_a
    valid_dates = []
    dates.each do |date|
      split_dates = date.split('/')
      split_dates.each do |item|
        item_values = item.split('-')
        if item_values.length == 2
          valid_dates.push Date.strptime(item, "%Y-%m").to_time.utc.iso8601
        elsif item_values.length == 3
          valid_dates.push Date.strptime(item, "%Y-%m-%d").to_time.utc.iso8601
        else
          valid_dates.push Date.strptime(item, "%Y").to_time.utc.iso8601
        end
      end
    end
    return nil if dates.blank?
    valid_dates
  rescue ArgumentError => e
    # We might want to start reporting metadata errors to Rollbar if we come up with a way to make them searchable and allow them to provide a feedback loop.
    # Rollbar.error(e, "Invalid date string encountered in normalized date field: #{date_string}")
    Rails.logger.error "event: metadata_error : Invalid date string encountered in normalized date field: #{dates}: #{e}"
    nil
  end

  def archival_collection
    parts = []
    parts << object.archival_collection_title if object.archival_collection_title
    
    # For the archival_collection_number, box, and folder, we check their presence
    # and format them according to their position.
    collection_details = []
    collection_details << object.archival_collection_number if object.archival_collection_number
    collection_details << object.archival_collection_box if object.archival_collection_box
    collection_details << object.archival_collection_folder if object.archival_collection_folder
    
    # Join the collection details with commas, and then append to parts with the necessary format.
    parts << "(#{collection_details.join(', ')})" unless collection_details.empty?
    
    # Finally, join the parts. If there was a title and additional details,
    # this will insert a space between them. Otherwise, it just returns whatever part is present.
    parts.join(' ')
  end
end
