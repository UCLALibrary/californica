# frozen_string_literal: true

class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :extent, predicate: 'http://purl.org/dc/elements/1.1/format' do |index|
    index.as :stored_searchable
  end

  property :local_identifier, predicate: ::RDF::Vocab::DC11.identifier
  property :funding_note, predicate: ::RDF::URI.intern('http://bibfra.me/vocab/marc/fundingInformation/')
  property :genre, predicate: ::RDF::Vocab::EDM.hasType
  property :normalized_date, predicate: ::RDF::Vocab::DC11.date
  property :repository, predicate: ::RDF::Vocab::MODS.locationCopySublocation
  property :latitude, predicate: ::RDF::Vocab::EXIF.gpsLatitude
  property :longitude, predicate: ::RDF::Vocab::EXIF.gpsLongitude

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
