# frozen_string_literal: true

##
# A `Darlingtonia::Parser` for MODS XML.
#
# Each `<mods:mods>` node in `file` is converted to an `InputRecord`.
#
# @example
#    parser = Darlingtonia::Parser.for(file: File.open('my_mods.xml'))
#
#    parser.records
#
class ModsXmlParser < Darlingtonia::Parser
  EXTENSION = '.xml'

  class << self
    ##
    # Matches all '.xml' filenames.
    def match?(file:, **_opts)
      File.extname(file) == EXTENSION
    rescue TypeError
      false
    end
  end

  ##
  # @return [Enumerable<InputRecord>]
  def records
    return enum_for(:records) unless block_given?

    file.rewind

    mods_nodes =
      Nokogiri::XML(file).xpath('//mods:mods', mapper_class::NAMESPACES)

    mods_nodes.each do |mods_node|
      yield Darlingtonia::InputRecord.from(metadata: mods_node,
                                           mapper:   mapper_class.new)
    end
  end

  private

    def mapper_class
      ModsMapper
    end
end
