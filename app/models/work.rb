# frozen_string_literal: true

class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :extent, predicate: ::RDF::Vocab::DC11.format do |index|
    index.as :stored_searchable, :facetable
  end

  property :caption, predicate: ::RDF::Vocab::SCHEMA.caption do |index|
    index.as :stored_searchable
  end

  property :dimensions, predicate: ::RDF::Vocab::MODS.physicalExtent do |index|
    index.as :stored_searchable, :facetable
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

  property :local_identifier, predicate: ::RDF::Vocab::DC11.identifier do |index|
    index.as :stored_searchable
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

  property :repository, predicate: ::RDF::Vocab::MODS.locationCopySublocation do |index|
    index.as :stored_searchable
  end

  property :rights_country, predicate: ::RDF::Vocab::EBUCore.rightsType do |index|
    index.as :stored_searchable
  end

  property :rights_holder, predicate: ::RDF::Vocab::EBUCore.hasRightsHolder do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
