# frozen_string_literal: true

class CsvImportOrderChild < ApplicationRecord
  serialize :error_messages, Array
  validates :ark, uniqueness: { scope: :csv_import_id, message: 'must be unique per CsvImport' }
end
