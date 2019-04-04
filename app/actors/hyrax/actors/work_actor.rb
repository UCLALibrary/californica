# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  module Actors
    class WorkActor < Hyrax::Actors::BaseActor
      def apply_save_data_to_curation_concern(env)
        raise "Cannot set id without a valid ark" unless env.attributes["ark"]
        ark_based_id = Californica::IdGenerator.id_from_ark(env.attributes["ark"])
        env.curation_concern.id = ark_based_id unless env.curation_concern.id
        super
      end
    end
  end
end
