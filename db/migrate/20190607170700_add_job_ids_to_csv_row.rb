class AddJobIdsToCsvRow < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_rows, :job_ids_queued, :text
    add_column :csv_rows, :job_ids_completed, :text
    add_column :csv_rows, :job_ids_errored, :text
  end
end
