# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  property :genre, predicate: 'http://purl.org/dc/elements/1.1/type' do |index|
    index.as :stored_searchable
  end
  property :extent, predicate: 'http://purl.org/dc/elements/1.1/format' do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
