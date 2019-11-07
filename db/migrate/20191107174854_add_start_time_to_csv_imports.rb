class AddStartTimeToCsvImports < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :start_time, :datetime
  end
end
