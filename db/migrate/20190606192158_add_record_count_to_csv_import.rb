class AddRecordCountToCsvImport < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :record_count, :integer
  end
end
