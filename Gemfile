# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '>= 2.4.0', '<= 2.5.99'

gem 'darlingtonia', '>= 3.2.0'

gem 'hyrax', '~> 2.2', '>= 2.3.3'
gem 'rails', '~> 5.1.6'

gem 'pkg-config', '~> 1.1'

# Error reporting tool
gem 'rollbar'

gem "bootstrap-sass", ">= 3.4.1"
# Use mysql
gem 'mysql2', '~> 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'coveralls', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'dotenv-rails', '~> 2.2.1'
gem 'hydra-role-management', '~> 1.0.0'
gem 'jquery-rails'
gem 'loofah', '>= 2.2.3'
gem 'rack', '>= 2.0.6'
gem 'retries'
gem 'riiif', '~> 1.1'
gem 'rsolr', '>= 1.0'
gem 'sidekiq', '~> 5.1.3'
gem 'sidekiq-failures'
gem 'whenever', require: false

group :development do
  # Use Capistrano for deployment automation
  gem "capistrano", "~> 3.11", require: false
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-ext'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rails-collection'
  gem 'capistrano-sidekiq', '~> 0.20.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'bixby', '~> 1.0.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'fcrepo_wrapper'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.16.1'
  gem 'solr_wrapper', '>= 0.3'
end
