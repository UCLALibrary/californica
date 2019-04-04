# frozen_string_literal: true
module Californica
  module IdGenerator
    # Take an ark value and return a valid fedora identifier
    def self.id_from_ark(ark)
      id = ark.gsub(/ark:?\/?/, '')
      shoulder, blade, extension = id.split('/')

      # didn't see {shoulder}/{blade} format ark
      raise ArgumentError, 'Could not parse ARK shoulder and blade' if blade.nil?
      # looks like an extended ark
      raise ArgumentError, 'ARK appears to have too many segments or extensions' unless extension.nil?

      "#{shoulder}-#{blade}".reverse
    end
  end
end
