# frozen_string_literal: true

class CsvImportsController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_preview, only: [:preview]

  with_themed_layout 'dashboard'

  def index; end

  def show; end

  def new; end

  # Validate the CSV file and display errors or
  # warnings to the user.
  def preview; end

  def create
    @csv_import.user = current_user
    preserve_cache

    if @csv_import.save
      @csv_import.queue_start_job
      redirect_to @csv_import
    else
      render :new
    end
  end

  private

    def load_and_authorize_preview
      @csv_import = CsvImport.new(create_params)
      authorize! :create, @csv_import
    end

    def create_params
      params.fetch(:csv_import, {}).permit(:manifest)
    end

    # Since we are re-rendering the form (once for
    # :new and again for :preview), we need to
    # manually set the cache, otherwise the record
    # will lose the manifest file between the preview
    # and the record save.
    def preserve_cache
      return unless params['csv_import']
      @csv_import.manifest_cache = params['csv_import']['manifest_cache']
    end
end
