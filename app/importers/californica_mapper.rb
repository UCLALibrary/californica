# frozen_string_literal: true

class CalifornicaMapper < Darlingtonia::HashMapper
  CALIFORNICA_TERMS_MAP = {
    identifier: "Item Ark",
    title: "Title",
    subject: "Subject"
  }.freeze

  DELIMITER = '|~|'

  def fields
    CALIFORNICA_TERMS_MAP.keys
  end

  def map_field(name)
    return unless CALIFORNICA_TERMS_MAP.keys.include?(name)

    metadata[name].split(DELIMITER)
  end
end
