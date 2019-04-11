class AddColumnImportFilePathToCsvImport < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :import_file_path, :string
  end
end
