class DropTableCreateCsvImportCreateManifests < ActiveRecord::Migration[5.1]
  def up
    drop_table :csv_import_create_manifests
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
