# frozen_string_literal: true
module UclaMetadata
  extend ActiveSupport::Concern

  included do
    property :ark, predicate: ::RDF::Vocab::DC11.identifier, multiple: false do |index|
      index.as :stored_sortable
    end

    property :extent, predicate: ::RDF::Vocab::DC11.format do |index|
      index.as :stored_searchable, :facetable
    end

    property :architect, predicate: ::RDF::Vocab::MARCRelators.arc do |index|
      index.as :stored_searchable
    end

    property :caption, predicate: ::RDF::Vocab::SCHEMA.caption do |index|
      index.as :stored_searchable
    end

    property :dimensions, predicate: ::RDF::Vocab::MODS.physicalExtent do |index|
      index.as :stored_searchable, :facetable
    end

    property :dlcs_collection_name, predicate: ::RDF::URI.intern('https://bib.schema.org/Collection') do |index|
      index.as :displayable, :facetable
    end

    property :funding_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/fundingInformation') do |index|
      index.as :stored_searchable
    end

    property :genre, predicate: ::RDF::Vocab::EDM.hasType do |index|
      index.as :stored_searchable, :facetable
    end

    property :latitude, predicate: ::RDF::Vocab::EXIF.gpsLatitude do |index|
      index.as :stored_searchable
    end

    property :location, predicate: ::RDF::Vocab::DC.coverage do |index|
      index.as :stored_searchable, :facetable
    end

    property :local_identifier, predicate: ::RDF::Vocab::Identifiers.local do |index|
      index.as :displayable, :facetable
    end

    property :longitude, predicate: ::RDF::Vocab::EXIF.gpsLongitude do |index|
      index.as :stored_searchable
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

    property :photographer, predicate: ::RDF::URI.intern('http://id.loc.gov/vocabulary/relators/pht.html') do |index|
      index.as :stored_searchable, :facetable
    end

    property :repository, predicate: ::RDF::Vocab::MODS.locationCopySublocation do |index|
      index.as :stored_searchable
    end

    property :rights_country, predicate: ::RDF::Vocab::EBUCore.rightsType do |index|
      index.as :stored_searchable
    end

    property :rights_holder, predicate: ::RDF::Vocab::EBUCore.hasRightsHolder do |index|
      index.as :stored_searchable
    end

    property :services_contact, predicate: ::RDF::Vocab::EBUCore.hasRightsContact do |index|
      index.as :displayable
    end
  end
end
