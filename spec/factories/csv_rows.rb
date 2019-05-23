FactoryBot.define do
  factory :csv_row do
    row_number { 1 }
    job_id { "MyString" }
    csv_import_id { "MyString" }
    status { "MyString" }
    error_messages { "MyText" }
    metadata { "MyText" }
  end
end
