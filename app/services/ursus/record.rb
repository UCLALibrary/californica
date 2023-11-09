# frozen_string_literal: true

module Ursus
  class Record
    def self.ursus_hostname
      ENV['URSUS_HOST']
    end

    # Note:  We can't use this to decide protocol:
    # `Rails.application.config.force_ssl`
    # because in our prod-like environments, we are
    # using Apache, not Rails, to configure TLS/SSL.
    def self.protocol
      return ENV['URSUS_PROTOCOL'] if ENV['URSUS_PROTOCOL']
      Rails.env.production? ? 'https://' : 'http://'
    end

    # @param record [Hyrax::WorkPresenter, Hyrax::CollectionPresenter, Work, Collection, SolrDocument, #id]
    # @return [String] the Ursus URL for this record
    def self.url_for(record)
      return unless ursus_hostname
      "#{protocol}#{ursus_hostname}/catalog/#{record.id}"
    end

    def self.url_for_ark(record)
      return unless ursus_hostname
      "#{protocol}#{ursus_hostname}/catalog/#{record.ark}"
    end
  end
end
