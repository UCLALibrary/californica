# frozen_string_literal: true
require 'sidekiq'
require 'sidekiq-status'

REDIS_EXPIRATION = 31.days

Sidekiq.configure_client do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: REDIS_EXPIRATION
end

Sidekiq.configure_server do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_server_middleware config, expiration: REDIS_EXPIRATION

  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: REDIS_EXPIRATION
end
