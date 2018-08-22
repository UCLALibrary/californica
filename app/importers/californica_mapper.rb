# frozen_string_literal: true

class CalifornicaMapper < Darlingtonia::HashMapper
  CALIFORNICA_TERMS_MAP = {
    identifier: "Item Ark",
    title: "Title",
    subject: "Subject"
  }.freeze

  def fields
    CALIFORNICA_TERMS_MAP.keys.reject do |e|
      next if e == :publisher_name
      metadata[CALIFORNICA_TERMS_MAP[e]].nil?
    end
  end

  def representative_file
    @metadata['file_name']
  end

  def map_field(name)
    return unless CALIFORNICA_TERMS_MAP.keys.include?(name)

    # Multivalue fields can be present in rows. When they occur, they have integers appended to them: name1, name2.
    # We check for multiple occurances of the name and integers (optionally), and return the values in an array.
    metadata.select do |k, val|
      val if k.match?(/^#{CALIFORNICA_TERMS_MAP[name]}[0-9]*$/)
    end.values
  end
end
