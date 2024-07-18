# frozen_string_literal: true

class MastersController < ApplicationController
  before_action :authenticate_user!

  def download
    raise ActionController::RoutingError, 'Master file download not supported' unless ENV['MASTERS_DIR']

    path = Rails.root.join(ENV['MASTERS_DIR'], sanitize_filename(params[:master_file_path]))
    if File.file?(path)
      send_file path
    elsif File.directory?(path)
      raise ActionController::RoutingError, 'Directory listing not supported'
    else
      raise ActionController::RoutingError, 'Not Found ' + ENV['MASTERS_DIR']
    end
  end

  private

    # modified from https://github.com/rails/rails/blob/0d30e84878223df68efda3b0e1741611d9682a45/activestorage/app/models/active_storage/filename.rb#L59C1-L61C6
    # we DON'T want to sanitize away '/' because we want to keep the path structure
    def sanitize_filename(filename)
      filename.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "�").strip.sub('../', '').tr("\u{202E}%$|:;\t\r\n\\", "-")
    end
end
