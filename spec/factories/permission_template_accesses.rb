# frozen_string_literal: true

# NB: Copied from Hyrax at https://github.com/samvera/hyrax/blob/master/spec/factories/permission_template_accesses.rb
FactoryBot.define do
  factory :permission_template_access, class: Hyrax::PermissionTemplateAccess do
    permission_template
    trait :manage do
      access { 'manage' }
    end

    trait :deposit do
      access { 'deposit' }
    end

    trait :view do
      access { 'view' }
    end
  end
end
