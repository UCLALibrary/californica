# frozen_string_literal: true
module UclaMetadata
  extend ActiveSupport::Concern

  included do
    property :ark, predicate: ::RDF::Vocab::DC11.identifier, multiple: false do |index|
      index.as :stored_sortable
    end

    property :content_disclaimer, predicate: ::RDF::URI.intern('http://bibfra.me/view/library/marc/intendedAudience') do |index|
      index.as :displayable
    end

    property :oai_set, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/lite/memberOf') do |index|
      index.as :symbol
    end

    # Item Overview
    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative, multiple: true do |index|
      index.as :stored_searchable
    end

    property :uniform_title, predicate: ::RDF::URI.intern('http://purl.org/dc/elements/1.1/title') do |index|
      index.as :stored_searchable, :facetable
    end

    property :creator, predicate: ::RDF::URI.intern('http://purl.org/dc/elements/1.1/creator') do |index|
      index.as :stored_searchable, :facetable
    end

    property :author, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/aut') do |index|
      index.as :stored_searchable, :facetable
    end

    property :edition, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/editionStatement') do |index|
      index.as :displayable
    end

    property :editor, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/edt') do |index|
      index.as :stored_searchable, :facetable
    end

    property :electronic_locator, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/electronicLocator'), multiple: false do |index|
      index.as :displayable
    end

    property :photographer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/pht.html') do |index|
      index.as :stored_searchable, :facetable
    end

    property :architect, predicate: ::RDF::Vocab::MARCRelators.arc do |index|
      index.as :stored_searchable, :facetable
    end

    property :illuminator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ilu') do |index|
      index.as :stored_searchable, :facetable
    end

    property :illustrator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ill.html') do |index|
      index.as :stored_searchable, :facetable
    end

    property :engraver, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/egr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :printmaker, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/prm') do |index|
      index.as :stored_searchable, :facetable
    end

    property :scribe, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/scr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :translator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/trl') do |index|
      index.as :stored_searchable, :facetable
    end

    property :rubricator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/rbr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :calligrapher, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/cll') do |index|
      index.as :stored_searchable, :facetable
    end

    property :commentator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/cmm') do |index|
      index.as :stored_searchable, :facetable
    end

    property :lyricist, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/lyr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :composer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/cmp') do |index|
      index.as :stored_searchable, :facetable
    end

    property :normalized_date, predicate: ::RDF::Vocab::DC11.date do |index|
      index.as :stored_searchable, :facetable
    end

    property :place_of_origin, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/prp.html') do |index|
      index.as :stored_searchable, :facetable
    end

    property :publisher, predicate: ::RDF::URI.intern('http://purl.org/dc/elements/1.1/publisher') do |index|
      index.as :stored_searchable
    end

    property :artist, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/art') do |index|
      index.as :stored_searchable, :facetable
    end

    property :cartographer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ctg') do |index|
      index.as :stored_searchable, :facetable
    end

    property :director, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/drt') do |index|
      index.as :stored_searchable, :facetable
    end

    property :interviewee, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ive') do |index|
      index.as :stored_searchable, :facetable
    end

    property :interviewer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ivr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :producer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/pro') do |index|
      index.as :stored_searchable, :facetable
    end

    property :recipient, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/rcp') do |index|
      index.as :stored_searchable, :facetable
    end

    property :host, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/hst') do |index|
      index.as :stored_searchable, :facetable
    end

    property :musician, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/mus') do |index|
      index.as :stored_searchable, :facetable
    end

    property :printer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/prt') do |index|
      index.as :stored_searchable, :facetable
    end

    property :researcher, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/res') do |index|
      index.as :stored_searchable, :facetable
    end

    # Notes
    property :summary, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Summary') do |index|
      index.as :stored_searchable
    end

    property :caption, predicate: ::RDF::Vocab::SCHEMA.caption do |index|
      index.as :stored_searchable
    end

    property :history, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/historyOfWork') do |index|
      index.as :stored_searchable
    end

    property :provenance, predicate: ::RDF::URI.intern('http://purl.org/dc/terms/provenance') do |index|
      index.as :stored_searchable
    end

    property :note_admin, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/adminMetadata') do |index|
      index.as :stored_searchable
    end

    # References
    property :citation_source, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/citationSource') do |index|
      index.as :stored_searchable
    end

    property :contents_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/contentsNote') do |index|
      index.as :stored_searchable
    end

    property :colophon, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Production') do |index|
      index.as :stored_searchable
    end

    property :note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/lite/note') do |index|
      index.as :stored_searchable
    end

    property :resp_statement, predicate: ::RDF::URI.intern('https://id.loc.gov/ontologies/bibframe.html#p_responsibilityStatement') do |index|
      index.as :stored_searchable
    end

    property :toc, predicate: ::RDF::URI.intern('http://purl.org/dc/terms/tableOfContents') do |index|
      index.as :stored_searchable
    end

    # Physical Description
    property :extent, predicate: ::RDF::Vocab::DC11.format do |index|
      index.as :stored_searchable, :facetable
    end

    property :dimensions, predicate: ::RDF::Vocab::MODS.physicalExtent do |index|
      index.as :stored_searchable, :facetable
    end

    property :support, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/BaseMaterial') do |index|
      index.as :stored_searchable, :facetable
    end

    property :medium, predicate: ::RDF::Vocab::DC.medium do |index|
      index.as :stored_searchable, :facetable
    end

    property :page_layout, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe.html#p_layout') do |index|
      index.as :symbol
    end

    property :binding_note, predicate: ::RDF::URI.intern('http://marc21rdf.info/elements/5XX/M563__a'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :condition_note, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3035'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :collation, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3077'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :foliation, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3076'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :illustrations_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/illustrations') do |index|
      index.as :stored_searchable
    end

    property :format_book, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/bookFormat') do |index|
      index.as :stored_searchable
    end

    # Keywords
    property :genre, predicate: ::RDF::Vocab::EDM.hasType do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject_topic, predicate: ::RDF::URI.intern('http://www.loc.gov/mods/rdf/v1#subjectTopic') do |index|
      index.as :stored_searchable, :facetable
    end

    property :named_subject, predicate: ::RDF::Vocab::MODS.subjectName do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject_geographic, predicate: ::RDF::URI.intern('http://www.loc.gov/mods/rdf/v1#subjectGeographic') do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject_temporal, predicate: ::RDF::URI.intern('http://www.loc.gov/mods/rdf/v1#subjectTemporal') do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject_cultural_object, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/natureOfContent') do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject_domain_topic, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Topic') do |index|
      index.as :stored_searchable, :facetable
    end

    property :series, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Series') do |index|
      index.as :stored_searchable, :facetable
    end

    property :location, predicate: ::RDF::Vocab::DC.coverage do |index|
      index.as :stored_searchable, :facetable
    end

    property :latitude, predicate: ::RDF::Vocab::EXIF.gpsLatitude do |index|
      index.as :stored_searchable
    end

    property :longitude, predicate: ::RDF::Vocab::EXIF.gpsLongitude do |index|
      index.as :stored_searchable
    end

    # Find This Item
    property :repository, predicate: ::RDF::Vocab::MODS.locationCopySublocation do |index|
      index.as :stored_searchable, :facetable
    end

    property :local_identifier, predicate: ::RDF::Vocab::Identifiers.local do |index|
      index.as :symbol
    end

    property :finding_aid_url, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/findingAid') do |index|
      index.as :displayable
    end

    property :identifier_global, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Identifier') do |index|
      index.as :symbol
    end

    property :opac_url, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/unimarc/terms/ter%23e'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :program, predicate: ::RDF::URI.intern('https://bib.schema.org/programName') do |index|
      index.as :stored_searchable, :facetable
    end

    # Access Condition
    property :services_contact, predicate: ::RDF::Vocab::EBUCore.hasRightsContact do |index|
      index.as :displayable
    end

    property :rights_holder, predicate: ::RDF::Vocab::EBUCore.hasRightsHolder do |index|
      index.as :stored_searchable
    end

    property :rights_country, predicate: ::RDF::Vocab::EBUCore.rightsType do |index|
      index.as :stored_searchable
    end

    property :funding_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/fundingInformation') do |index|
      index.as :stored_searchable
    end

    property :access_copy, predicate: ::RDF::URI.intern('http://www.europeana.eu/schemas/edm/object'), multiple: false do |index|
      index.as :stored_sortable
    end

    # ---------------

    property :dlcs_collection_name, predicate: ::RDF::URI.intern('https://bib.schema.org/Collection') do |index|
      index.as :displayable, :facetable
    end

    property :featured_image, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3080'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :iiif_manifest_url, predicate: ::RDF::URI.intern('http://iiif.io/api/presentation/2#Manifest'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :iiif_range, predicate: ::RDF::URI.intern('http://iiif.io/api/presentation/2#Range'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :iiif_text_direction, predicate: ::RDF::URI.intern('http://iiif.io/api/presentation/2#viewingDirection'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :iiif_viewing_hint, predicate: ::RDF::URI.intern('http://iiif.io/api/presentation/2#ViewingHint'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :masthead_parameters, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3078'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :preservation_copy, predicate: ::RDF::URI.intern('https://pcdm.org/models#hasFile'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :related_record, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/accompaniedBy') do |index|
      index.as :displayable
    end

    property :related_to, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/relatedTo') do |index|
      index.as :displayable
    end

    property :representative_image, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3079'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :tagline, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3081'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :thumbnail_link, predicate: ::RDF::URI.intern('http://pcdm.org/use#ThumbnailImage'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :local_rights_statement, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/UsePolicy') do |index|
      index.as :displayable
    end
  end
end

# https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer/DefaultDescriptors#simple-class_method
# displayable: https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer%2FDefaultDescriptors.displayable
# stored_searchable https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer%2FDefaultDescriptors.stored_searchable
# stored_sortable https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer%2FDefaultDescriptors.stored_sortable
# :facetable - combined with adding field-name_sim to the config.add_show_field in app/controllers/catalog_controler.rb
# in Ursus this creates a link on the item/show page of Ursus that links to a search for all fields of this name
