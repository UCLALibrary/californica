# frozen_string_literal: true

module Californica
  class CsvImportService
    def initialize(csv_import)
      @csv_import = csv_import
    end

    def csv
      status = {}
      csv_rows.each do |row|
        metadata = JSON.parse(row.metadata)
        status[metadata['Item ARK']] = row.status
      end

      new_csv = CSV.read(@csv_import.manifest.to_s, headers: true)
      new_csv.each do |row|
        row["Import Status"] = status[row["Item ARK"]]
      end

      new_csv
    end

    private

      def csv_rows
        @csv_rows ||= @csv_import.csv_rows
      end
  end
end
