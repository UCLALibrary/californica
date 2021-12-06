# frozen_string_literal: true

class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include UclaMetadata
  include ::Discoverable

  self.indexer = WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :ark, presence: { message: 'Your Work must have an ARK.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  # @param ark [String] The ARK
  # @return [Work] The Work with that ARK
  def self.find_by_ark(ark)
    where(ark_ssi: ark).limit(1).first
  end

  # @param ark [String] The ARK
  # @return [Work] The Work with that ARK
  def self.find_or_create_by_ark(ark)
    begin
      work = find_by_ark(ark)
      return work if work
    rescue ActiveFedora::ObjectNotFoundError
    end

    work = Work.create(
      id: Californica::IdGenerator.id_from_ark(ark),
      title: ["Work #{ark}"],
      ark: ark,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
      admin_set_id: AdminSet.find_or_create_default_admin_set_id,
      depositor: ::User.batch_user.user_key,
      edit_users: [::User.batch_user.user_key]
    )
    work
  end
end
