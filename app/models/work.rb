# frozen_string_literal: true

class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :extent, predicate: 'http://purl.org/dc/elements/1.1/format'
  property :caption, predicate: ::RDF::Vocab::SCHEMA.caption do |index|
    index.as :stored_searchable
  end
  property :dimensions, predicate: ::RDF::Vocab::MODS.physicalExtent
  property :funding_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/fundingInformation/')
  property :genre, predicate: ::RDF::Vocab::EDM.hasType
  property :latitude, predicate: ::RDF::Vocab::EXIF.gpsLatitude
  property :local_identifier, predicate: ::RDF::Vocab::DC11.identifier
  property :location, predicate: ::RDF::Vocab::DC.coverage do |index|
    index.as :stored_searchable
  end
  property :longitude, predicate: ::RDF::Vocab::EXIF.gpsLongitude
  property :medium, predicate: ::RDF::Vocab::DC.medium
  property :named_subject, predicate: ::RDF::Vocab::MODS.subjectName do |index|
    index.as :stored_searchable
  end
  property :normalized_date, predicate: ::RDF::Vocab::DC11.date
  property :repository, predicate: ::RDF::Vocab::MODS.locationCopySublocation
  property :rights_country, predicate: ::RDF::Vocab::EBUCore.rightsType
  property :rights_holder, predicate: ::RDF::Vocab::EBUCore.hasRightsHolder

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
