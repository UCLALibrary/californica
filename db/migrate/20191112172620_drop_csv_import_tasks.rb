class DropCsvImportTasks < ActiveRecord::Migration[5.1]
  def up
    drop_table :csv_import_tasks
  end

  def down
    create_table "csv_import_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.bigint "csv_import_id"
      t.string "job_status"
      t.string "job_type"
      t.string "item_ark"
      t.string "object_type"
      t.float "job_duration", limit: 24
      t.integer "times_started"
      t.timestamp "start_timestamp"
      t.timestamp "end_timestamp"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["csv_import_id"], name: "index_csv_import_tasks_on_csv_import_id"
    end
    add_foreign_key "csv_import_tasks", "csv_imports"
  end
end
