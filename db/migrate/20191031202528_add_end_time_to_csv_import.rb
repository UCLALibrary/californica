class AddEndTimeToCsvImport < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :end_time, :datetime
  end
end
