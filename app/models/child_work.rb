# frozen_string_literal: true
class ChildWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include UclaMetadata

  self.indexer = WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :ark, presence: { message: 'Your Work must have an ARK.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
