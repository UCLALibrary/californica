# frozen_string_literal: true
class CsvImport < ApplicationRecord
  belongs_to :user
  mount_uploader :manifest, CsvManifestUploader

  delegate :warnings, to: :manifest, prefix: true

  delegate :errors, to: :manifest, prefix: true
end
