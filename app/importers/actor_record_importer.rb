# frozen_string_literal: true

class ActorRecordImporter < Darlingtonia::HyraxRecordImporter
  include CommonRecordImporter

  DEFAULT_CREATOR_KEY = 'californica_import_user@example.com'

  ##
  # @!attribute [rw] creator
  #   @return [User]
  attr_accessor :creator

  ##
  # @param creator   [User]
  def initialize(error_stream: Darlingtonia.config.default_error_stream,
                 info_stream: Darlingtonia.config.default_info_stream,
                 attributes: {})
    super(error_stream: error_stream, info_stream: info_stream, attributes: attributes)
  end

  # Create an object using the Hyrax actor stack
  # We assume the object was created as expected if the actor stack returns true.
  def create_for(record:)
    info_stream << "event: record_import_started, batch_id: #{batch_id}, collection_id: #{collection_id}, record_title: #{record.respond_to?(:title) ? record.title : record}"

    additional_attrs = {
      uploaded_files: create_upload_files(record),
      depositor: @depositor.user_key,
      batch_id: batch_id
    }

    created = import_type.new

    attrs = record.attributes.merge(additional_attrs)

    attrs = attrs.merge(member_of_collections_attributes: { '0' => { id: collection_id } }) if collection_id

    # Ensure nothing is passed in the files field,
    # since this is reserved for Hyrax and is where uploaded_files will be attached
    attrs.delete(:files)
    attrs.delete(:uploaded_files)

    based_near = attrs.delete(:based_near)
    attrs = attrs.merge(based_near_attributes: based_near_attributes(based_near)) unless based_near.nil? || based_near.empty?

    actor_env = Hyrax::Actors::Environment.new(created,
                                               ::Ability.new(@depositor),
                                               attrs)
    terminator = Hyrax::Actors::Terminator.new
    middleware = Californica::IngestMiddlewareStack.build_stack.build(terminator)

    if middleware.create(actor_env)
      info_stream << "event: record_created, batch_id: #{batch_id}, record_id: #{created.id}, collection_id: #{collection_id}, record_title: #{attrs[:title]&.first}"
      @success_count += 1
    else
      created.errors.each do |attr, msg|
        error_stream << "event: validation_failed, batch_id: #{batch_id}, collection_id: #{collection_id}, attribute: #{attr.capitalize}, message: #{msg}, record_title: record_title: #{attrs[:title] ? attrs[:title] : attrs}"
      end
      @failure_count += 1
    end
  end
end
