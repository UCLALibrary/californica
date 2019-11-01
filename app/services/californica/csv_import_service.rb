# frozen_string_literal: true

module Californica
  class CsvImportService
    def initialize(csv_import)
      @csv_import = csv_import
    end

    def csv
      status = {}
      rows.each do |row|
        metadata = JSON.parse(row.metadata)
        status[metadata['Item ARK']] = row.status
      end

      new_csv = CSV.read(@csv_import.manifest.to_s, headers: true)
      new_csv.each do |row|
        row["Import Status"] = status[row["Item ARK"]]
      end

      new_csv
    end

    def update_status
      return if unfinished_rows? || unfinished_tasks?

      @csv_import.status = 'complete'
      @csv_import.end_time = [last_row_end_time, last_task_end_time].max
      @csv_import.elapsed_time = @csv_import.end_time - (@csv_import.start_time || @csv_import.created_at)
      @csv_import.elapsed_time_per_record = @csv_import.elapsed_time / @csv_import.record_count
      @csv_import.save
    end

    private

      def last_row_end_time
        rows.maximum(:ingest_record_end_time) || rows.maximum(:updated_at)
      end

      def last_task_end_time
        tasks.maximum(:end_timestamp) || tasks.maximum(:updated_at)
      end

      def rows
        @rows ||= @csv_import.csv_rows
      end

      def tasks
        @tasks ||= @csv_import.csv_import_tasks
      end

      def unfinished_rows?
        rows.where.not(status: ['complete', 'error']).count.positive?
      end

      def unfinished_tasks?
        tasks.where.not(job_status: ['complete', 'error']).count.positive?
      end
  end
end
