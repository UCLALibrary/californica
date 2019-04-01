# frozen_string_literal: true
# Generated by hyrax:models
class Collection < ActiveFedora::Base
  include ::Hyrax::CollectionBehavior
  include UclaMetadata

  # You can replace these metadata if they're not suitable
  include Hyrax::BasicMetadata
  self.indexer = ::CollectionIndexer

  # @param ark [String] The ARK
  # @return [Collection] The Collection with that ARK
  def self.find_by_ark(ark)
    where(ark_sim: ark).limit(1).first
  end

  # @param ark [String] The ARK
  # @return [Collection] The Collection with that ARK
  def self.find_or_create_by_ark(ark)
    collection = find_by_ark(ark)
    return collection if collection

    collection = Collection.create(
      id: Californica::IdGenerator.id_from_ark(ark),
      title: ["Collection #{ark}"],
      ark: ark,
      collection_type: Hyrax::CollectionType.find_or_create_default_collection_type,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )

    # Members of the 'admin' group can edit this Collection
    grants = [{ agent_type: 'group', agent_id: 'admin', access: Hyrax::PermissionTemplateAccess::MANAGE }]
    Hyrax::Collections::PermissionsCreateService.create_default(collection: collection, creating_user: User.batch_user, grants: grants)

    collection
  end
end
