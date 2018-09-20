# frozen_string_literal: true

class CalifornicaMapper < Darlingtonia::HashMapper
  CALIFORNICA_TERMS_MAP = {
    identifier: "Item Ark",
    title: "Title",
    subject: "Subject",
    description: "Description.note",
    resource_type: "Type.typeOfResource",
    latitude: "Description.latitude",
    longitude: "Description.longitude",
    extent: "Format.extent",
    local_identifier: "Alternate Identifier.local",
    date_created: "Date.creation",
    caption: "Description.caption",
    dimensions: "Format.dimensions",
    funding_note: "Description.fundingNote",
    genre: "Type.genre",
    rights_holder: "Rights.rightsHolderContact",
    medium: "Format.medium",
    normalized_date: "Date.normalized",
    repository: "Name.repository"
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
    if ladnn?
      ['1 photograph']
    else
      map_field(:extent)
    end
  end

  # Hard-code repository for LADNN collection. Story #121
  def repository
    if ladnn?
      ['University of California, Los Angeles. Library. Department of Special Collections']
    else
      map_field(:repository)
    end
  end

  def ladnn?
    metadata['Project Name'] == 'Los Angeles Daily News Negatives'
  end

  def map_field(name)
    return unless CALIFORNICA_TERMS_MAP.keys.include?(name)

    metadata[CALIFORNICA_TERMS_MAP[name]]&.split(DELIMITER)
  end
end
