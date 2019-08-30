class AddIngestDurationToCsvRow < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_rows, :ingest_duration, :float
  end
end
