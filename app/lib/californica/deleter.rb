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

    # Modified to ensure all works are deleted before deleting the collection
    def delete_collection_with_works(of_type: nil)
      log('In delete_collection_with_works start.')
      works = work_id_list
      log("Number of works in collection #{id}: #{works.count}") # Log the number of works
      all_works_deleted = works.empty? || delete_works(of_type: of_type)
      if all_works_deleted && (of_type.nil? || record.is_a?(of_type))
        delete
        true
      else
        log('Deletion skipped for some works.')
        false
      end
    end

    # Ensures all works are deleted; returns true if successful
    def delete_works(of_type: nil)
      work_id_list.empty? || work_id_list.all? do |work_id|
        Californica::Deleter.new(id: work_id, logger: logger)
                            .delete_with_children(of_type: of_type)
      end
    end

    # Modified to ensure all works are deleted before deleting the collection
    def delete_with_children(of_type: nil)
      log('In delete_with_children start.')
      if can_delete_with_children?(of_type)
        delete
        true
      else
        log('Deletion skipped for some child works.')
        false
      end
    end

    # Ensures all child works are deleted; returns true if successful
    def delete_children(of_type: nil)
      record&.member_ids&.empty? || record&.member_ids&.all? do |child_id|
        Californica::Deleter.new(id: child_id, logger: logger)
                            .delete_with_children(of_type: of_type)
      end
    end

    private

      def can_delete_with_children?(of_type)
        children_deleted_or_none?(of_type) && deletion_type_matches?(of_type)
      end

      def children_deleted_or_none?(of_type)
        children = record&.member_ids
        children.nil? || children.empty? || delete_children(of_type: of_type)
      end

      def deletion_type_matches?(of_type)
        of_type.nil? || record.is_a?(of_type)
      end

      def destroy_and_eradicate
        start_time = Time.current
        record&.destroy&.eradicate
        Hyrax.config.callback.run(:after_destroy, record.id, User.batch_user)
        log("Deleted #{record.class} #{record.id} in #{ActiveSupport::Duration.build(Time.current - start_time)}")
        log("deleted item ark is: #{record.ark}")
      rescue Ldp::HttpError, Faraday::TimeoutError, Faraday::ConnectionFailed => e
        log("#{e.class}: #{e.message}")
        retries ||= 0
        if (retries += 1) > 3
          return false # Explicitly return false after retries are exhausted
        else
          retry
        end
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
