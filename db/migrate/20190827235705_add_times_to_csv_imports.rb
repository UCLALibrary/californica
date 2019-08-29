class AddTimesToCsvImports < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :elapsed_time, :float
    add_column :csv_imports, :elapsed_time_per_record, :float
  end
end
