# frozen_string_literal: true

##
# A metadata mapper for UCLA MODS XML
class ModsMapper < Darlingtonia::MetadataMapper
  NAMESPACES = { 'mods' => 'http://www.loc.gov/mods/v3' }.freeze

  def fields
    [:title]
  end

  def title
    metadata
      &.xpath('//mods:mods/mods:titleInfo/mods:title', NAMESPACES)
      &.map(&:text) || []
  end
end
