# frozen_string_literal: true

class CalifornicaMapper < Darlingtonia::HashMapper
  CALIFORNICA_TERMS_MAP = {
    identifier: "Item Ark",
    title: "Title",
    subject: "Subject",
    description: "Description.note",
    extent: "Format.extent"
  }.freeze

  DELIMITER = '|~|'

  def fields
    CALIFORNICA_TERMS_MAP.keys + [:visibility]
  end

  def visibility
    Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end

  # To avoid having to normalize data before import,
  # if the collection is LADNN, hard-code the extent. (Story #111)
  def extent
    if metadata['Project Name'] == 'Los Angeles Daily News Negatives'
      ['1 photograph']
    else
      map_field(:extent)
    end
  end

  def map_field(name)
    return unless CALIFORNICA_TERMS_MAP.keys.include?(name)

    metadata[CALIFORNICA_TERMS_MAP[name]]&.split(DELIMITER)
  end
end
