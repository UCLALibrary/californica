# frozen_string_literal: true

module Californica
  class Deleter
    attr_reader :id, :logger

    def initialize(id: nil, record: nil, logger: Rails.logger)
      @id = id || record.id
      @record = record
      @logger = logger

      raise ArgumentError "id #{@id} does not match record #{@record}" if @record && @record.id != @id
    rescue NoMethodError
      raise ArgumentError 'Californica::Deleter must be initialized with a fcrepo id or a Californica record object (Collection, Work, or ChildWork).'
    end

    def delete
      destroy_and_eradicate
    end

    def delete_collection_with_works(of_type: nil)
      # replace log to puts when running locally
      log('In delete_collection_with_works start.')
      delete_works(of_type: of_type)
      delete if of_type.nil? || record.is_a?(of_type)
      log('In delete_collection_with_works stop.')
    end

    def delete_works(of_type: nil)
      # log('In delete_works start.')
      work_id_list&.each do |work_id|
        Californica::Deleter.new(id: work_id, logger: logger)
                            .delete_with_children(of_type: of_type)
      end
      # log('In delete_works end.')
    end

    def delete_with_children(of_type: nil)
      # log('In delete_with_children start.')
      delete_children(of_type: of_type)
      delete if of_type.nil? || record.is_a?(of_type)
      # log('In delete_with_children end.')
    end

    def delete_children(of_type: nil)
      # log('In delete_children start.')
      record&.member_ids&.each do |child_id|
        Californica::Deleter.new(id: child_id, logger: logger)
                            .delete_with_children(of_type: of_type)
      end
      # log('In delete_children end.')
    end

    private

      def destroy_and_eradicate
        start_time = Time.current
        record&.destroy&.eradicate
        Hyrax.config.callback.run(:after_destroy, record.id, User.batch_user)
        log("Deleted #{record.class} #{record.id} in #{ActiveSupport::Duration.build(Time.current - start_time)}")
        log("deleted item ark is: #{record.ark}")
      rescue Ldp::HttpError, Faraday::TimeoutError, Faraday::ConnectionFailed => e
        log("#{e.class}: #{e.message}")
        retries ||= 0
        retry if (retries += 1) <= 3
      end

      def delete_from_fcrepo
        ActiveFedora.fedora.connection.delete(ActiveFedora::Base.id_to_uri(id))
        log("Forced delete of record from Fedora")
      rescue Ldp::NotFound
        nil # Everything's good, we just wanted to make sure there wasn't a record in fedora not indexed to solr
      end

      def log(message, status: :info)
        Rollbar.send((Rollbar.respond_to?(status) ? status : :info), message, id: id)
        if logger.respond_to?(status)
          logger.send(status, "#{message} (#{record_name})")
        elsif logger.respond_to?(:<<)
          logger << "#{status}: #{message} (#{record_name})"
        end
      end

      def record
        @record ||= ActiveFedora::Base.find(id)

      rescue ActiveFedora::ObjectNotFoundError
        delete_from_fcrepo
      end

      def record_name
        @record ? "#{record.class} #{record.ark}" : id
      end

      def solr
        Blacklight.default_index.connection
      end

      # Get the list of IDs from the query results:
      def work_id_list
        query = { params: { q: "member_of_collection_ids_ssim:#{id} AND has_model_ssim:Work", fl: "id", rows: "100000" } }
        results = solr.select(query)
        results['response']['docs'].flat_map(&:values)
      end
  end
end
