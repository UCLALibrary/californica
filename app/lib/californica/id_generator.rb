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
      ark_parts = id.split('/')

      # didn't see {shoulder}/{blade} format ark
      raise ArgumentError, 'Could not parse ARK shoulder and blade' if ark_parts.count < 2

      ark_parts.join('-')
    end
  end
end
