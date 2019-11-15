class CreateCsvCollectionReindices < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_collection_reindices do |t|
      t.string :ark
      t.string :csv_import_id
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
