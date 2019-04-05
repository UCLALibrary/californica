# frozen_string_literal: true
class ImporterDocumentationController < ApplicationController
  def guide; end

  def csv
    send_file Rails.root.join('app', 'assets', 'csv', 'import_manifest.csv'), type: 'text/csv; charset=utf-8', disposition: 'attachment', filename: 'import_manifest.csv'
  end
end
