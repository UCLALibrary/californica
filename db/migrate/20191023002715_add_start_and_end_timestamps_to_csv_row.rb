class AddStartAndEndTimestampsToCsvRow < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_rows, :start_time, :timestamp 
    add_column  :csv_rows, :end_time, :timestamp
  end
end
