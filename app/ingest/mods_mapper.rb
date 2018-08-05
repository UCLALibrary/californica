# frozen_string_literal: true

##
# A metadata mapper for UCLA MODS XML
class ModsMapper < Darlingtonia::MetadataMapper
  NAMESPACES = { 'mods' => 'http://www.loc.gov/mods/v3' }.freeze

  def fields
    [:title, :depositor, :extent, :genre]
  end

  def title
    metadata
      &.xpath('//mods:mods/mods:titleInfo/mods:title', NAMESPACES)
      &.map(&:text) || []
  end

  def extent
    metadata
      &.xpath('//mods:mods/mods:physicalDescription/mods:extent', NAMESPACES)
      &.map(&:text) || []
  end

  def genre
    metadata
      &.xpath('//mods:mods/mods:genre', NAMESPACES)
      &.map(&:text) || []
  end

  def depositor
    User.batch_user.user_key
  end
end
