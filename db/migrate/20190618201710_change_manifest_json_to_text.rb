class ChangeManifestJsonToText < ActiveRecord::Migration[5.1]
  def change
    change_column(:manifests, :json, :text)
  end
end
