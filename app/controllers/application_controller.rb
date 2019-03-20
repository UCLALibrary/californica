# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  skip_after_action :discard_flash_if_xhr
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController

  # Check to see if we're in read_only mode
  before_action :check_read_only, except: [:show, :index]

  with_themed_layout '1_column'

  protect_from_forgery with: :exception

  # What to do if read_only mode has been enabled, via FlipFlop
  # If read_only is enabled, redirect any requests that would allow
  # changes to the system. This is to enable easier migrations.
  def check_read_only
    return unless Flipflop.read_only?
    # Exempt the FlipFlop controller itself from read_only mode, so it can be turned off
    return if self.class.to_s == Hyrax::Admin::StrategiesController.to_s
    redirect_back(
      fallback_location: root_path,
      alert: "This system is in read-only mode for maintenance. No submissions or edits can be made at this time."
    )
  end
end
