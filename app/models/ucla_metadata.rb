# frozen_string_literal: true
module UclaMetadata
  extend ActiveSupport::Concern

  included do
    property :access_copy, predicate: ::RDF::URI.intern('http://www.europeana.eu/schemas/edm/object'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative, multiple: true do |index|
      index.as :stored_searchable
    end

    property :ark, predicate: ::RDF::Vocab::DC11.identifier, multiple: false do |index|
      index.as :stored_sortable
    end

    property :architect, predicate: ::RDF::Vocab::MARCRelators.arc do |index|
      index.as :stored_searchable
    end

    property :author, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/aut') do |index|
      index.as :stored_searchable
    end

    property :binding_note, predicate: ::RDF::URI.intern('http://marc21rdf.info/elements/5XX/M563__a'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :caption, predicate: ::RDF::Vocab::SCHEMA.caption do |index|
      index.as :stored_searchable
    end

    property :calligrapher, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/cll') do |index|
      index.as :stored_searchable
    end

    property :collation, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3077'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :condition_note, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3035'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :colophon, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Production') do |index|
      index.as :stored_searchable
    end

    property :commentator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/cmm') do |index|
      index.as :stored_searchable, :facetable
    end

    property :composer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/cmp') do |index|
      index.as :stored_searchable, :facetable
    end

    property :dimensions, predicate: ::RDF::Vocab::MODS.physicalExtent do |index|
      index.as :stored_searchable, :facetable
    end

    property :dlcs_collection_name, predicate: ::RDF::URI.intern('https://bib.schema.org/Collection') do |index|
      index.as :displayable, :facetable
    end

    property :editor, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/edt') do |index|
      index.as :stored_searchable
    end

    property :engraver, predicate: ::RDF::URI.intern('hhttp://id.loc.gov/vocabulary/relators/egr') do |index|
      index.as :stored_searchable
    end

    property :extent, predicate: ::RDF::Vocab::DC11.format do |index|
      index.as :stored_searchable, :facetable
    end

    property :featured_image, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3080'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :finding_aid_url, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/findingAid') do |index|
      index.as :displayable
    end

    property :foliation, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3076'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :funding_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/fundingInformation') do |index|
      index.as :stored_searchable
    end

    property :genre, predicate: ::RDF::Vocab::EDM.hasType do |index|
      index.as :stored_searchable, :facetable
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

    property :illuminator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ilu') do |index|
      index.as :stored_searchable, :facetable
    end

    property :illustrations_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/illustrations') do |index|
      index.as :stored_searchable
    end

    property :illustrator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/ill.html') do |index|
      index.as :stored_searchable
    end

    property :latitude, predicate: ::RDF::Vocab::EXIF.gpsLatitude do |index|
      index.as :stored_searchable
    end

    property :local_identifier, predicate: ::RDF::Vocab::Identifiers.local do |index|
      index.as :displayable, :facetable
    end

    # property :local_rights_statement, predicate: ::RDF::URI.intern('http://purl.org/dc/terms/rights') do |index|
    # index.as :symbol
    # end # This invokes License renderer from hyrax gem

    property :location, predicate: ::RDF::Vocab::DC.coverage do |index|
      index.as :stored_searchable, :facetable
    end

    property :longitude, predicate: ::RDF::Vocab::EXIF.gpsLongitude do |index|
      index.as :stored_searchable
    end

    property :lyricist, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/lyr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :masthead_parameters, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3078'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :medium, predicate: ::RDF::Vocab::DC.medium do |index|
      index.as :stored_searchable, :facetable
    end

    property :named_subject, predicate: ::RDF::Vocab::MODS.subjectName do |index|
      index.as :stored_searchable, :facetable
    end

    property :normalized_date, predicate: ::RDF::Vocab::DC11.date do |index|
      index.as :stored_searchable, :facetable
    end

    property :note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/lite/note') do |index|
      index.as :stored_searchable
    end

    property :opac_url, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/unimarc/terms/ter%23e'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :page_layout, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe.html#p_layout') do |index|
      index.as :symbol
    end

    property :photographer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/pht.html') do |index|
      index.as :stored_searchable, :facetable
    end

    property :place_of_origin, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/prp.html') do |index|
      index.as :stored_searchable, :facetable
    end

    property :preservation_copy, predicate: ::RDF::URI.intern('https://pcdm.org/models#hasFile'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :printmaker, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/prm') do |index|
      index.as :stored_searchable
    end

    property :provenance, predicate: ::RDF::URI.intern('http://purl.org/dc/terms/provenance') do |index|
      index.as :stored_searchable
    end

    property :repository, predicate: ::RDF::Vocab::MODS.locationCopySublocation do |index|
      index.as :stored_searchable
    end

    property :representative_image, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3079'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :rights_country, predicate: ::RDF::Vocab::EBUCore.rightsType do |index|
      index.as :stored_searchable
    end

    property :rights_holder, predicate: ::RDF::Vocab::EBUCore.hasRightsHolder do |index|
      index.as :stored_searchable
    end

    property :rubricator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/rbr') do |index|
      index.as :stored_searchable
    end

    property :scribe, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/scr') do |index|
      index.as :stored_searchable, :facetable
    end

    property :services_contact, predicate: ::RDF::Vocab::EBUCore.hasRightsContact do |index|
      index.as :displayable
    end

    property :subject_topic, predicate: ::RDF::URI.intern('http://www.loc.gov/mods/rdf/v1#subjectTopic') do |index|
      index.as :stored_searchable
    end

    property :subject_geographic, predicate: ::RDF::URI.intern('http://www.loc.gov/mods/rdf/v1#subjectGeographic') do |index|
      index.as :stored_searchable
    end

    property :subject_temporal, predicate: ::RDF::URI.intern('http://www.loc.gov/mods/rdf/v1#subjectTemporal') do |index|
      index.as :stored_searchable
    end

    property :summary, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/Summary') do |index|
      index.as :stored_searchable
    end

    property :support, predicate: ::RDF::URI.intern('http://id.loc.gov/ontologies/bibframe/BaseMaterial') do |index|
      index.as :stored_searchable, :facetable
    end

    property :tagline, predicate: ::RDF::URI.intern('http://iflastandards.info/ns/fr/frbr/frbrer/P3081'), multiple: false do |index|
      index.as :stored_sortable
    end

    property :toc, predicate: ::RDF::URI.intern('http://purl.org/dc/terms/tableOfContents') do |index|
      index.as :stored_searchable
    end

    property :translator, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/trl') do |index|
      index.as :stored_searchable
    end

    property :uniform_title, predicate: ::RDF::URI.intern('http://purl.org/dc/elements/1.1/title') do |index|
      index.as :stored_searchable
    end
  end
end

# https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer/DefaultDescriptors#simple-class_method
# displayable: https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer%2FDefaultDescriptors.displayable
# stored_searchable https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer%2FDefaultDescriptors.stored_searchable
# stored_sortable https://www.rubydoc.info/gems/solrizer/3.4.0/Solrizer%2FDefaultDescriptors.stored_sortable
