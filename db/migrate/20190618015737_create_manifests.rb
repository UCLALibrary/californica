class CreateManifests < ActiveRecord::Migration[5.1]
  def change
    create_table :manifests do |t|
      t.text :json

      t.timestamps
    end
  end
end
