class AddStatusToCsvImport < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :status, :string
  end
end
