class CsvImport < ApplicationRecord
  belongs_to :user
  mount_uploader :manifest, CsvManifestUploader

  def manifest_warnings
    manifest.warnings
  end

  def manifest_errors
    manifest.errors
  end
end
