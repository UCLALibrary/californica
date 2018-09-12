# frozen_string_literal: true

class CalifornicaMapper < Darlingtonia::HashMapper
  CALIFORNICA_TERMS_MAP = {
    identifier: "Item Ark",
    title: "Title",
    subject: "Subject",
    description: "Description.note"
  }.freeze

  DELIMITER = '|~|'

  def fields
    CALIFORNICA_TERMS_MAP.keys + [:visibility]
  end

  def visibility
    Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end

  def map_field(name)
    return unless CALIFORNICA_TERMS_MAP.keys.include?(name)

    metadata[CALIFORNICA_TERMS_MAP[name]]&.split(DELIMITER)
  end
end
