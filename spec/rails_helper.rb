# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'active_fedora/cleaner'
require 'ffaker'

ENV['IMPORT_FILE_PATH'] = "#{::Rails.root}/spec/fixtures"
ENV['MISSING_FILE_LOG'] = "#{::Rails.root}/log/missing_files_test"
ENV['IMPORT_PATH'] = "#{::Rails.root}/spec/fixtures"
ENV['UPLOAD_PATH'] = "#{::Rails.root}/tmp/uploads"
ENV['CACHE_PATH'] = "#{::Rails.root}/tmp/uploads/cache"

# Allow Hyrax to upload files from the fixtures directory. Needed for testing
# file attachment.
Hyrax.config.whitelisted_ingest_dirs << "#{::Rails.root}/spec/fixtures"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :googlebot do |app|
  browser_options.args << '--user-agent Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.register_driver :selenium_chrome_headless_sandboxless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--no-sandbox'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.default_driver = :rack_test # This is a faster driver
Capybara.javascript_driver = :selenium_chrome_headless_sandboxless # This is slower

RSpec.configure do |config|
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless_sandboxless
  end

  config.before(:each, type: :system, js: false) do
    driven_by :rack_test
  end

  config.before(:suite) do
    ActiveJob::Base.queue_adapter = :test
    ActiveFedora::Cleaner.clean!
  end

  config.before(clean: true) do
    ActiveFedora::Cleaner.clean!
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include Devise::Test::ControllerHelpers, type: :controller
end
