# frozen_string_literal: true
module Californica
  module IdGenerator
    # Take an ark value and return a valid fedora identifier
    def self.id_from_ark(ark)
      blacklight_id_from_ark(ark).reverse
    end

    # Take an ark value and return an identifier that can be used in blacklight catalog controllers
    def self.blacklight_id_from_ark(ark)
      id = ark.gsub(/\s+/, "").gsub(/ark:?\/?/, '')
      shoulder, blade, extension = id.split('/')

      # didn't see {shoulder}/{blade} format ark
      raise ArgumentError, 'Could not parse ARK shoulder and blade' if blade.nil?
      # looks like an extended ark
      raise ArgumentError, 'ARK appears to have too many segments or extensions' unless extension.nil?

      "#{shoulder}-#{blade}"
    end
  end
end
