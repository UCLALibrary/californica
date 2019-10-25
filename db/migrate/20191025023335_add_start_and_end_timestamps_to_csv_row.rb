class AddStartAndEndTimestampsToCsvRow < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_rows, :ingest_record_start_time, :timestamp 
    add_column :csv_rows, :ingest_record_end_time, :timestamp
  end
end
