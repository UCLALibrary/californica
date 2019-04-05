class AddManifestToCsvImports < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_imports, :manifest, :string
  end
end
