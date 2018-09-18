# frozen_string_literal: true
# See https://github.com/ffaker/ffaker for more fake data
FactoryBot.define do
  factory :work do
    id { Noid::Rails::Service.new.mint }
    title { [] << FFaker::Book.title }
    subject { [] << FFaker::Education.major }
    description { [] << FFaker::Lorem.paragraph }
    visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  end
end
