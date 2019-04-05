class CreateCsvImports < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_imports do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
