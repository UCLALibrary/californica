# frozen_string_literal: true

FactoryBot.define do
  factory :csv_import_task do
    csv_import { nil }
    job_status { "MyString" }
    job_type { "MyString" }
    item_ark { "MyString" }
    object_type { "MyString" }
    job_duration { 1.5 }
    times_started { 1 }
    start_timestamp { "2019-10-11 10:38:15" }
    end_timestamp { "2019-10-11 10:38:15" }
  end
end
