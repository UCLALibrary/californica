class CreateCsvRows < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_rows do |t|
      t.integer :row_number
      t.string :job_id
      t.string :csv_import_id
      t.string :status
      t.text :error_messages
      t.text :metadata

      t.timestamps
    end
  end
end
