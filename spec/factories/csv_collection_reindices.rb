# frozen_string_literal: true

FactoryBot.define do
  factory :csv_collection_reindex do
    ark { "MyString" }
    csv_import_id { "MyString" }
    status { "Complete" }
    error_messages { ["Error 1", "Error 2"] }
    start_time { "2019-11-12 09:36:56" }
    end_time { "2019-11-12 09:36:56" }
    elapsed_time { 1.5 }
    no_of_children { 1 }
  end
end
