class CreateCsvImportTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_import_tasks do |t|
      t.references :csv_import, foreign_key: true
      t.string :job_status
      t.string :job_type
      t.string :item_ark
      t.string :object_type
      t.float :job_duration
      t.integer :times_started
      t.timestamp :start_timestamp
      t.timestamp :end_timestamp

      t.timestamps
    end
  end
end
