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
      rows: 10,
      qf: 'title_tesim description_tesim creator_tesim keyword_tesim'
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name('title', :stored_searchable)
    config.index.display_type_field = solr_name('has_model', :symbol)
    config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field solr_name('resource_type', :facetable), label: 'Resource Type', limit: 5
    config.add_facet_field solr_name('creator', :facetable), limit: 5
    config.add_facet_field solr_name('contributor', :facetable), label: 'Contributor', limit: 5
    config.add_facet_field solr_name('keyword', :facetable), limit: 5
    config.add_facet_field solr_name('subject', :facetable), limit: 5
    config.add_facet_field solr_name('language', :facetable), limit: 5
    config.add_facet_field solr_name('file_format', :facetable), limit: 5
    config.add_facet_field solr_name('member_of_collection_ids', :symbol), limit: 5, label: 'Collections', helper_method: :collection_title_by_id
    config.add_facet_field solr_name('repository', :facetable), limit: 5
    config.add_facet_field solr_name('normalized_date', :facetable), label: 'Normalized Date', limit: 5
    config.add_facet_field solr_name('named_subject', :facetable), label: 'Name (Subject)', limit: 5
    config.add_facet_field solr_name('rights_country', :facetable), limit: 5
    config.add_facet_field solr_name('medium', :facetable), label: 'Medium', limit: 5
    config.add_facet_field solr_name('dimensions', :facetable), label: 'Dimensions', limit: 5
    config.add_facet_field solr_name('extent', :facetable), label: 'Extent', limit: 5
    config.add_facet_field solr_name('genre', :facetable), label: 'Genre', limit: 5
    config.add_facet_field solr_name('location', :facetable), label: 'Location', limit: 5

    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field solr_name('generic_type', :facetable), if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name('title', :stored_searchable), label: 'Title', itemprop: 'name', if: false
    config.add_index_field solr_name('description', :stored_searchable), itemprop: 'Description', helper_method: :iconify_auto_link
    config.add_index_field solr_name('normalized_date', :stored_searchable), label: 'Date', link_to_search: solr_name('normalized_date', :facetable)
    config.add_index_field solr_name('resource_type', :stored_searchable), label: 'Resource Type', link_to_search: solr_name('resource_type', :facetable)

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field solr_name('title', :stored_searchable)
    config.add_show_field solr_name('description', :stored_searchable)
    config.add_show_field solr_name('keyword', :stored_searchable)
    config.add_show_field solr_name('subject', :stored_searchable)
    config.add_show_field solr_name('creator', :stored_searchable)
    config.add_show_field solr_name('contributor', :stored_searchable)
    config.add_show_field solr_name('publisher', :stored_searchable)
    config.add_show_field solr_name('based_near_label', :stored_searchable)
    config.add_show_field solr_name('language', :stored_searchable)
    config.add_show_field solr_name('date_uploaded', :stored_searchable)
    config.add_show_field solr_name('date_modified', :stored_searchable)
    config.add_show_field solr_name('date_created', :stored_searchable)
    config.add_show_field solr_name('rights_statement', :stored_searchable)
    config.add_show_field solr_name('license', :stored_searchable)
    config.add_show_field solr_name('resource_type', :stored_searchable), label: 'Resource Type'
    config.add_show_field solr_name('format', :stored_searchable)
    config.add_show_field solr_name('identifier', :stored_searchable)

    config.add_show_field solr_name('caption', :stored_searchable)
    config.add_show_field solr_name('dimensions', :stored_searchable)
    config.add_show_field solr_name('extent', :stored_searchable)
    config.add_show_field solr_name('funding_note', :stored_searchable)
    config.add_show_field solr_name('genre', :stored_searchable)
    config.add_show_field solr_name('location', :stored_searchable)
    config.add_show_field solr_name('local_identifier', :stored_searchable)
    config.add_show_field solr_name('medium', :stored_searchable)
    config.add_show_field solr_name('named_subject', :stored_searchable)
    config.add_show_field solr_name('normalized_date', :stored_searchable)
    config.add_show_field solr_name('repository', :stored_searchable)
    config.add_show_field solr_name('rights_country', :stored_searchable)
    config.add_show_field solr_name('rights_holder', :stored_searchable)

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
      search_fields = 'title_tesim subject_tesim named_subject_tesim location_tesim description_tesim caption_tesim identifier_tesim local_identifier_tesim normalized_date_tesim photographer_tesim'

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
    config.add_search_field('contributor') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = solr_name('contributor', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('creator') do |field|
      solr_name = solr_name('creator', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      solr_name = solr_name('title', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('description') do |field|
      field.label = 'Abstract or Summary'
      solr_name = solr_name('description', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      solr_name = solr_name('publisher', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      solr_name = solr_name('created', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      solr_name = solr_name('subject', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      solr_name = solr_name('language', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('resource_type') do |field|
      solr_name = solr_name('resource_type', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('format') do |field|
      solr_name = solr_name('format', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      solr_name = solr_name('id', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near') do |field|
      field.label = 'Location'
      solr_name = solr_name('based_near_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('keyword') do |field|
      solr_name = solr_name('keyword', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      solr_name = solr_name('depositor', :symbol)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights_statement') do |field|
      solr_name = solr_name('rights_statement', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('license') do |field|
      solr_name = solr_name('license', :stored_searchable)
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
