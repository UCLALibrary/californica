# frozen_string_literal: true
module Californica
  module TextDirectionService
    ##
    # @!attribute [rw] authority
    #   @return [Qa::Authorities::Base]
    mattr_accessor :authority
    self.authority = Qa::Authorities::Local.subauthority_for('text_directions')

    ##
    # @return [Array<Array<String, String>>] a collection of [label, id] pairs
    def self.select_options
      authority.all.map do |element|
        [element[:label], element[:id]]
      end
    end

    ##
    # @param id [String] the authority id to look up
    #
    # @return [String] the `term` matching the authority id
    #
    # @raise [ResourceTypeService::LookupError]
    def self.label(id)
      authority.find(id).fetch('term') do
        raise LookupError,
              "Tried to look up missing label for Text direction: #{id}"
      end
    end

    class LookupError < ArgumentError; end
  end
end
