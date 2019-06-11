# frozen_string_literal: true

# This module adds a new value for visibility called
# "discovery", which is meant to allow users to view
# the metadata for a Work, but not see attached files.
#
# This module overrides some methods and behavior from
# the hydra-access-controls gem.

module Discoverable
  extend ActiveSupport::Concern

  VISIBILITY_TEXT_VALUE_DISCOVERY = 'discovery'

  def visibility=(value)
    if value == VISIBILITY_TEXT_VALUE_DISCOVERY
      discovery_visibility!
    else
      super
    end
  end

  # Note that visibility is a derived field.  It is calculated based on the values of the access control groups.
  def visibility
    if read_groups.include? ::Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC
      ::Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    elsif read_groups.include? ::Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED
      ::Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    elsif discover_groups.include? ::Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC
      VISIBILITY_TEXT_VALUE_DISCOVERY
    else
      ::Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
  end

  def discovery_visibility!
    visibility_will_change! unless visibility == VISIBILITY_TEXT_VALUE_DISCOVERY
    set_read_groups([], represented_visibility)
    set_discover_groups([Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC], [])
  end

  def private_visibility!
    super
    set_discover_groups([], represented_visibility)
  end

  def registered_visibility!
    super
    set_discover_groups([], represented_visibility)
  end

  def public_visibility!
    super
    set_discover_groups([], represented_visibility)
  end

  def permissions_attributes=(attributes_collection)
    if attributes_collection.is_a? Hash
      keys = attributes_collection.keys
      attributes_collection = if keys.include?('id') || keys.include?(:id)
                                Array(attributes_collection)
                              else
                                attributes_collection.sort_by { |i, _| i.to_i }.map { |_, attributes| attributes }
                              end
    end

    attributes_collection = attributes_collection.map(&:with_indifferent_access)
    attributes_collection.each do |prop|
      existing = case prop[:type]
                 when 'group'
                   search_by_type(:group)
                 when 'person'
                   search_by_type(:person)
                 end

      next if existing.blank?

      # This is the part we are overriding in californica
      selected = existing.find { |perm| (perm.agent_name == prop[:name]) && (perm.access == prop[:access]) }

      prop['id'] = selected.id if selected
    end

    clean_collection = remove_bad_deletes(attributes_collection)

    self.permissions_attributes_without_uniqueness = clean_collection
  end
end
