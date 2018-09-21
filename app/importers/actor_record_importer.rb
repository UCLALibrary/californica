# frozen_string_literal: true

class ActorRecordImporter < Darlingtonia::RecordImporter
  DEFAULT_CREATOR_KEY = 'californica_import_user@example.com'

  ##
  # @!attribute [rw] creator
  #   @return [User]
  attr_accessor :creator

  ##
  # @param creator   [User]
  def initialize(*)
    self.creator = User.find_or_create_system_user(DEFAULT_CREATOR_KEY)

    super
  end

  private

    def create_for(record:)
      info_stream << 'Creating record: ' \
                     "#{record.respond_to?(:title) ? record.title : record}."

      created    = import_type.new
      attributes = record.attributes
      actor_env  = Hyrax::Actors::Environment.new(created,
                                                  ::Ability.new(creator),
                                                  attributes)

      if Hyrax::CurationConcern.actor.create(actor_env)
        info_stream << "Record created at: #{created.id}"
      else
        created.errors.each do |attr, msg|
          error_stream << "Validation failed: #{attr.capitalize}. #{msg}"
        end
      end
    end
end
