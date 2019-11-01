# frozen_string_literal: true
class CsvImport < ApplicationRecord
  belongs_to :user
  mount_uploader :manifest, CsvManifestUploader
  delegate :warnings, to: :manifest, prefix: true
  delegate :errors, to: :manifest, prefix: true
  delegate :records, to: :manifest, prefix: true
  has_many :csv_rows
  has_many :csv_import_tasks

  def queue_start_job
    StartCsvImportJob.perform_later(id)
    # TODO: We'll probably need to store job_id on this record.
  end
end
