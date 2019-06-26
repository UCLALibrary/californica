# frozen_string_literal: true
# See https://github.com/ffaker/ffaker for more fake data
FactoryBot.define do
  factory :work do
    transient do
      tif { nil }
      child_work { nil }
    end

    after(:build) do |work, evaluator|
      if evaluator.tif
        file_set = FactoryBot.create(:file_set)
        Hydra::Works::UploadFileToFileSet.call(file_set, evaluator.tif)
        work.ordered_members << file_set
        work.save
      end

      if evaluator.child_work
        work.ordered_members << evaluator.child_work
        work.save
      end
    end

    id { Noid::Rails::Service.new.mint }
    ark { "ark:/13030/#{Noid::Rails::Service.new.mint}" }
    title { [] << FFaker::Book.title }
    subject { [] << FFaker::Education.major }
    description { [] << FFaker::Lorem.paragraph }
    visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    date_modified { '09-09-1999'.to_datetime }
  end
end
