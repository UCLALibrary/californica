# frozen_string_literal: true

class Ark
  # If I pass in an ARK that doesn't already have the
  # "ark:/" prefix, add the prefix onto the string.
  # For example, convert "123/456" to "ark:/123/456"
  def self.ensure_prefix(ark)
    return if ark.blank?
    if ark.start_with?(prefix)
      ark
    else
      prefix + ark
    end
  end

  def self.prefix
    'ark:/'
  end
end
