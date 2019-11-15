# frozen_string_literal: true

FactoryBot.define do
  factory :csv_import_order_child do
    ark { "MyString" }
    csv_import_id { 1 }
    status { "MyString" }
    error_messages { ["MyString"] }
    start_time { "2019-11-13 12:29:45" }
    end_time { "2019-11-13 12:29:45" }
    elapsed_time { 1.5 }
    no_of_children { 1 }
  end
end
