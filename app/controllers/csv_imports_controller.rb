# frozen_string_literal: true

class CsvImportsController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_preview, only: [:preview]

  with_themed_layout 'dashboard'

  def index; end

  def show
    @csv_rows = CsvRow.where(csv_import_id: @csv_import.id)
    respond_to do |format|
      format.html do
        @min_ingest_duration = min
        @max_ingest_duration = max
        @mean_ingest_duration = mean
        @median_ingest_duration = median
        @standard_deviation_ingest_duration = std_deviation
        @min_ingest_duration = min
      end
      format.csv { send_data service.status_csv, filename: File.basename(@csv_import.manifest.to_s) }
    end
  end

  def new; end

  # Validate the CSV file and display errors or
  # warnings to the user.
  def preview; end

  def create
    @csv_import.user = current_user
    @csv_import.import_file_path = '/opt/data'
    preserve_cache
    if @csv_import.save
      @csv_import.queue_start_job
      redirect_to @csv_import
    else
      render :new
    end
  end

  def log
    log_file = Rails.root.join('log', "ingest_#{params[:id]}.log")
    log_text = if File.exist?(log_file)
                 File.open(log_file).read
               else
                 'Could not read a log file for this import'
               end
    render plain: log_text
  end

  private

    def service
      @service ||= CsvImportService.new @csv_import
    end

    def load_and_authorize_preview
      @csv_import = CsvImport.new(create_params)
      authorize! :create, @csv_import
    end

    def create_params
      params.fetch(:csv_import, {}).permit(:manifest, :manifest_records)
    end

    # Since we are re-rendering the form (once for
    # :new and again for :preview), we need to
    # manually set the cache, otherwise the record
    # will lose the manifest file between the preview
    # and the record save.
    def preserve_cache
      return unless params['csv_import']
      @csv_import.manifest_cache = params['csv_import']['manifest_cache']
      @csv_import.record_count = params['csv_import']['record_count']
    end

    def row_times
      @row_times ||= @csv_rows.select('ingest_duration')
    end

    def min
      if @csv_rows.count == @csv_import.record_count
        @min_ingest_duration = row_times.minimum(:ingest_duration)
        @min_ingest_duration.round(2)
      end
    end

    def max
      if @csv_rows.count == @csv_import.record_count
        @max_ingest_duration = row_times.maximum(:ingest_duration)
        @max_ingest_duration.round(2)
      end
    end

    def mean
      if @csv_rows.count == @csv_import.record_count
        @mean_ingest_duration = row_times.average(:ingest_duration)
        @mean_ingest_duration.round(2)
      end
    end

    def median
      if @csv_rows.count == @csv_import.record_count
        @get_ingest_duration_rows = row_times
        durations = @get_ingest_duration_rows.map(&:ingest_duration)
        sorted = durations.compact.sort
        len = sorted.length
        ((sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0).round(2) if len.positive?
      end
    end

    def std_deviation
      if @csv_rows.count == @csv_import.record_count
        @get_ingest_duration_rows = row_times
        durations = @get_ingest_duration_rows.map(&:ingest_duration)
        @avg = CsvRow.where(csv_import_id: @csv_import.id).average(:ingest_duration)
        sd = Math.sqrt(durations.sum { |x| (x - @avg)**2 } / @get_ingest_duration_rows.size)
        sd.round(2)
      end
    end
end
