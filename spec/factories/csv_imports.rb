# frozen_string_literal: true
FactoryBot.define do
  factory :csv_import do
    user { nil }
    manifest { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'csv_import', 'import_manifest.csv'), 'text/csv') }
  end
end
