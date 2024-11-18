# frozen_string_literal: true
class CatalogController < ApplicationController
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior

  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  def self.uploaded_field
    solr_name('system_create', :stored_sortable, type: :date)
  end

  def self.modified_field
    solr_name('system_modified', :stored_sortable, type: :date)
  end

  configure_blacklight do |config|
    # Blacklight will use POST instead of GET for solr
    config.http_method = :post
    config.crawler_detector = ->(_req) { true }
    config.view.gallery.partials = %i[index_header index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.search_builder_class = Hyrax::CatalogSearchBuilder

    # Show gallery view
    config.view.gallery.partials = %i[index_header index]
    config.view.slideshow.partials = [:index]

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      mm: '100%',
      rows: 10,
      qf: 'title_tesim description_tesim creator_tesim keyword_tesim'
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name('title', :stored_searchable)
    config.index.display_type_field = solr_name('has_model', :symbol)
    config.index.thumbnail_field = 'thumbnail_url_ss'

    # FACETS
    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field solr_name('human_readable_resource_type', :facetable), label: 'Resource Type', limit: 5
    config.add_facet_field solr_name('creator', :facetable), limit: 5
    config.add_facet_field solr_name('contributor', :facetable), label: 'Contributor', limit: 5
    config.add_facet_field solr_name('keyword', :facetable), limit: 5
    config.add_facet_field solr_name('subject', :facetable), limit: 5
    config.add_facet_field solr_name('subject_geographic', :facetable), label: 'Subject geographic', limit: 5
    config.add_facet_field solr_name('subject_temporal', :facetable), label: 'Subject temporal', limit: 5
    config.add_facet_field solr_name('subject_cultural_object', :facetable), label: 'Subject cultural object', limit: 5
    config.add_facet_field solr_name('subject_domain_topic', :facetable), label: 'Subject domain topic', limit: 5
    config.add_facet_field solr_name('human_readable_language', :facetable), label: 'Language', limit: 5
    config.add_facet_field solr_name('file_format', :facetable), limit: 5
    config.add_facet_field solr_name('member_of_collections', :symbol), limit: 5, label: 'Collection'
    config.add_facet_field solr_name('repository', :facetable), limit: 5
    config.add_facet_field solr_name('normalized_date', :facetable), label: 'Normalized Date', limit: 5
    config.add_facet_field solr_name('named_subject', :facetable), label: 'Names', limit: 5
    config.add_facet_field solr_name('rights_country', :facetable), limit: 5
    config.add_facet_field solr_name('medium', :facetable), label: 'Medium', limit: 5
    config.add_facet_field solr_name('dimensions', :facetable), label: 'Dimensions', limit: 5
    config.add_facet_field solr_name('extent', :facetable), label: 'Extent', limit: 5
    config.add_facet_field solr_name('genre', :facetable), label: 'Genre', limit: 5
    config.add_facet_field solr_name('location', :facetable), label: 'Location', limit: 5
    config.add_facet_field solr_name('series', :facetable), label: 'Series', limit: 5
    config.add_facet_field solr_name('host', :facetable), label: 'Host', limit: 5
    config.add_facet_field solr_name('musician', :facetable), label: 'Musician', limit: 5
    config.add_facet_field solr_name('printer', :facetable), label: 'Printer', limit: 5
    config.add_facet_field solr_name('researcher', :facetable), label: 'Researcher', limit: 5
    config.add_facet_field solr_name('arranger', :facetable), label: 'Arranger', limit: 5
    config.add_facet_field solr_name('collector', :facetable), label: 'Collector', limit: 5
    config.add_facet_field solr_name('librettist', :facetable), label: 'Librettist', limit: 5

    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field solr_name('generic_type', :facetable), if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # ------------------------------------------------------
    # INDEX / SEARCH RESULTS
    # solr fields to be displayed in the index (search results) view
    # The ordering of the field names is the order of the display
    config.add_index_field 'title_tesim', label: 'Title', itemprop: 'name', if: false
    config.add_index_field 'description_tesim', itemprop: 'Description', helper_method: :iconify_auto_link
    config.add_index_field 'normalized_date_tesim', label: 'Date', link_to_search: solr_name('normalized_date', :facetable)

    # Currently disabled resource_type in index view bc the implementation makes it hard to tap into our custom presenter
    config.add_index_field 'human_readable_resource_type_tesim', label: 'Resource Type', link_to_search: solr_name('human_readable_resource_type', :facetable)

    # ------------------------------------------------------
    # SHOW PAGE / ITEM PAGE / Individual Work (Universal Viewer Page)
    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'title_tesim'
    config.add_show_field 'description_tesim'
    config.add_show_field 'keyword_tesim'
    config.add_show_field 'subject_tesim'
    config.add_show_field 'creator_tesim'
    config.add_show_field 'contributor_tesim'
    config.add_show_field 'publisher_tesim'
    config.add_show_field 'based_near_label_tesim'
    config.add_show_field 'language_tesim'
    config.add_show_field 'date_uploaded_tesim'
    config.add_show_field 'date_modified_tesim'
    config.add_show_field 'date_created_tesim'
    config.add_show_field 'rights_statement_tesim'
    config.add_show_field 'license_tesim'
    config.add_show_field 'resource_type_tesim', label: 'Resource Type'
    config.add_show_field 'format_tesim'
    config.add_show_field 'identifier_tesim', label: 'Identifier'
    config.add_show_field 'ark_ssi', label: 'ARK'
    config.add_show_field 'access_copy_ssi'

    config.add_show_field 'alternative_title_tesim'
    config.add_show_field 'architect_tesim'
    config.add_show_field 'artist_tesim'
    config.add_show_field 'author_tesim'
    config.add_show_field 'binding_note_ssi'
    config.add_show_field 'calligrapher_tesim'
    config.add_show_field 'caption_tesim'
    config.add_show_field 'cartographer_tesim'
    config.add_show_field 'citation_source_tesim', label: 'References'
    config.add_show_field 'collation_ssi'
    config.add_show_field 'colophon_tesim'
    config.add_show_field 'content_disclaimer_ssm', label: 'Disclaimer'
    config.add_show_field 'composer_tesim'
    config.add_show_field 'commentator_tesim'
    config.add_show_field 'condition_note_ssi'
    config.add_show_field 'contents_note_tesim'
    config.add_show_field 'dimensions_tesim'
    config.add_show_field 'director_tesim'
    config.add_show_field 'edition_ssm', label: 'Edition'
    config.add_show_field 'editor_tesim'
    config.add_show_field 'electronic_locator_ss', label: 'External item record'
    config.add_show_field 'engraver_tesim'
    config.add_show_field 'extent_tesim'
    config.add_show_field 'finding_aid_url_ssm'
    config.add_show_field 'foliation_ssi', label: 'Foliation note'
    config.add_show_field 'format_book_tesim', label: 'Format'
    config.add_show_field 'funding_note_tesim'
    config.add_show_field 'genre_tesim'
    config.add_show_field 'history_tesim', label: 'History'
    config.add_show_field 'host_tesim'
    config.add_show_field 'iiif_manifest_url_ssi'
    config.add_show_field 'iiif_range_ssi'
    config.add_show_field 'iiif_viewing_hint_ssi'
    config.add_show_field 'illuminator_tesim'
    config.add_show_field 'illustrations_note_tesim'
    config.add_show_field 'illustrator_tesim'
    config.add_show_field 'interviewee_tesim'
    config.add_show_field 'interviewer_tesim'
    config.add_show_field 'location_tesim'
    config.add_show_field 'local_identifier_ssim'
    config.add_show_field 'lyricist_tesim'
    config.add_show_field 'masthead_parameters_ssi'
    config.add_show_field 'medium_tesim'
    config.add_show_field 'musician_tesim'
    config.add_show_field 'named_subject_tesim'
    config.add_show_field 'normalized_date_tesim'
    config.add_show_field 'note_admin_tesim', label: 'AdminNote'
    config.add_show_field 'note_tesim'
    config.add_show_field 'opac_url_ssi'
    config.add_show_field 'page_layout_ssim'
    config.add_show_field 'photographer_tesim'
    config.add_show_field 'place_of_origin_tesim'
    config.add_show_field 'preservation_copy_ssi'
    config.add_show_field 'printer_tesim'
    config.add_show_field 'printmaker_tesim'
    config.add_show_field 'producer_tesim'
    config.add_show_field 'program_tesim'
    config.add_show_field 'provenance_tesim'
    config.add_show_field 'recipient_tesim'
    config.add_show_field 'human_readable_related_record_title_ssm', label: 'Related Records', helper_method: :iconify_auto_link
    config.add_show_field 'related_to_ssm', label: 'Related Items'
    config.add_show_field 'repository_tesim'
    config.add_show_field 'researcher_tesim'
    config.add_show_field 'resp_statement_tesim', label: 'Statement of Responsibility'
    config.add_show_field 'rights_country_tesim'
    config.add_show_field 'rights_holder_tesim'
    config.add_show_field 'rubricator_tesim'
    config.add_show_field 'scribe_tesim'
    config.add_show_field 'subject_geographic_tesim'
    config.add_show_field 'subject_temporal_tesim'
    config.add_show_field 'subject_cultural_object_tesim'
    config.add_show_field 'subject_domain_topic_tesim'
    config.add_show_field 'subject_topic_tesim'
    config.add_show_field 'support_tesim'
    config.add_show_field 'summary_tesim'
    config.add_show_field 'iiif_text_direction_ssi'
    config.add_show_field 'toc_tesim'
    config.add_show_field 'thumbnail_link_ssi'
    config.add_show_field 'translator_tesim'
    config.add_show_field 'uniform_title_tesim'
    config.add_show_field 'representative_image_ssi'
    config.add_show_field 'featured_image_ssi'
    config.add_show_field 'tagline_ssi'
    config.add_show_field 'series_tesim'
    config.add_show_field 'local_rights_statement_ssm' # This invokes License renderer from hyrax gem
    config.add_show_field 'archival_collection_title_ssi'
    config.add_show_field 'archival_collection_number_ssi'
    config.add_show_field 'archival_collection_box_ssi'
    config.add_show_field 'archival_collection_folder_ssi'
    config.add_show_field 'arranger_tesim'
    config.add_show_field 'collector_tesim'
    config.add_show_field 'inscription_tesim'
    config.add_show_field 'librettist_tesim'
    config.add_show_field 'script_tesim'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: 'All Fields') do |field|
      search_fields = 'title_tesim subject_tesim named_subject_tesim location_tesim description_tesim caption_tesim identifier_tesim local_identifier_ssim ark_ssi normalized_date_tesim architect_tesim photographer_tesim'

      field.solr_parameters = {
        qf: search_fields,
        pf: 'title_tesim'
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    # creator, title, description, publisher, date_created,
    # subject, language, resource_type, format, identifier, based_near,
    # solr_parameters hash are sent to Solr as ordinary url query params.
    # :solr_local_parameters will be sent using Solr LocalParams
    # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    # Solr parameter de-referencing like $title_qf.
    # See: http://wiki.apache.org/solr/LocalParams

    [
      'arranger',
      'artist',
      'author',
      'cartographer',
      'citation_source',
      'collation',
      'collector',
      'colophon',
      'commentator',
      'composer',
      'contributor',
      'created',
      'creator',
      'director',
      'foliation',
      'format',
      'format_book',
      'host',
      'iiif_viewing_hint',
      'illuminator',
      'illustrator',
      'inscription',
      'interviewee',
      'interviewer',
      'keyword',
      'language',
      'librettist',
      'license',
      'lyricist',
      'musician',
      'note_admin',
      'printer',
      'producer',
      'program',
      'publisher',
      'recipient',
      'repository',
      'researcher',
      'resource_type',
      'resp_statement',
      'rights_statement',
      'rubricator',
      'scribe',
      'script',
      'series',
      'subject',
      'subject_cultural_object',
      'subject_domain_topic',
      'subject_geographic',
      'subject_temporal',
      'subject_topic',
      'summary',
      'support',
      'title',
      'translator',
      'uniform_title',
    ].each do |field_name|
      config.add_search_field(field_name) do |field|
        solr_name = solr_name(field_name, :stored_searchable)
        field.solr_local_parameters = {
          qf: solr_name,
          pf: solr_name
        }
      end
    end

    config.add_search_field('description') do |field|
      field.label = 'Abstract or Summary'
      solr_name = solr_name('description', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    {
      'date_created' => 'created',
      'based_near' => 'based_near_label',
      'identifier' => 'id',
    }.each do |field_name, field_solr_name|
        config.add_search_field(field_name) do |field|
        solr_name = solr_name(field_solr_name, :stored_searchable)
        field.solr_local_parameters = {
          qf: solr_name,
          pf: solr_name
        }
      end
    end

    [
      'binding_note',
      'opac_url',
      'iiif_manifest_url'
    ].each do |field_name|
      config.add_search_field(field_name) do |field|
        solr_name = solr_name(field_name, :stored_sortable)
        field.solr_local_parameters = {
          qf: solr_name,
          pf: solr_name
        }
      end
    end

    config.add_search_field('depositor') do |field|
      solr_name = solr_name('depositor', :symbol)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: 'relevance'
    config.add_sort_field 'title_alpha_numeric_ssort asc', label: "Title \u25BC"
    config.add_sort_field 'title_alpha_numeric_ssort desc', label: "Title \u25B2"
    config.add_sort_field 'date_dtsort desc', label: "Date created \u25BC"
    config.add_sort_field 'date_dtsort asc', label: "Date created \u25B2"
    config.add_sort_field "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "date modified \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  # disable the bookmark control from displaying in gallery view
  # Hyrax doesn't show any of the default controls on the list view, so
  # this method is not called in that context.
  def render_bookmarks_control?
    false
  end
end

# https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer/DefaultDescriptors#simple-class_method
