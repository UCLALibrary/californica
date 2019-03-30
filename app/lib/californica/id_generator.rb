# frozen_string_literal: true
module Californica
  module IdGenerator
    # Take an ark value and return a valid fedora identifier
    def self.id_from_ark(ark)
      split = ark.split('/')
      shoulder = split[-2]
      blade = split[-1]
      "#{blade}-#{shoulder}"
    end
  end
end
