class AddObjectTypeToCsvRow < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_rows, :object_type, :string
  end
end
