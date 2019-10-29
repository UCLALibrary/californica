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

  before_action :authenticate_user!

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

  private

    def authenticate_user!
      return if whitelisted_path?
      if !user_signed_in?
        redirect_to('/users/sign_in', alert: 'Administrator accounts are required to access Californica. Please sign in or create a new account (then ask us to grant it admin privileges)') unless user_signed_in? && user.admin?
      elsif !current_user.admin?
        redirect_to('/users/sign_out', alert: "#{current_user.email} is not an administrator. Please request admin priviliges or use a different account.")
      end
    end

    def whitelisted_path?
      # allow creation of new accounts
      return true if request.path == '/users' && request.method == 'POST'

      # allow a few whitelisted paths
      return true if ['/users/sign_in', '/users/sign_up', '/users/sign_out'].include?(request.path)

      # allow IIIF manifests to be served
      route = Rails.application.routes.recognize_path(request.path)
      return true if ['hyrax/works', 'hyrax/child_works'].include?(route[:controller]) && route[:action] == 'manifest'

      false
    rescue ActionController::RoutingError
      return false
    end
end
