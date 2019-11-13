class CreateCsvImportCreateManifests < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_import_create_manifests do |t|
      t.string :ark
      t.integer :csv_import_id
      t.string :status
      t.string :error_messages
      t.timestamp :start_time
      t.timestamp :end_time
      t.float :elapsed_time
      t.integer :no_of_children

      t.timestamps
    end
  end
end
