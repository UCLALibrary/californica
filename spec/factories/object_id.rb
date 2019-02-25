# frozen_string_literal: true

# NB: Copied from Hyrax at https://github.com/samvera/hyrax/blob/master/spec/factories/object_id.rb
# Defines a new sequence
FactoryBot.define do
  sequence :object_id do |n|
    "object_id_#{n}"
  end
end
