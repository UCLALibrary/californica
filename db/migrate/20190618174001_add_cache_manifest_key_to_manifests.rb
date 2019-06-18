class AddCacheManifestKeyToManifests < ActiveRecord::Migration[5.1]
  def change
    add_column :manifests, :cache_manifest_key, :string
  end
end
