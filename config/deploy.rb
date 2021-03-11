# frozen_string_literal: true
# config valid for current version and patch releases of Capistrano
lock ">= 3.11.0"

set :application, "californica"
set :repo_url, "https://github.com/UCLALibrary/californica.git"

set :deploy_to, '/opt/californica'
set :rails_env, 'production'

if ENV['VIA_JUMP'] == "yes"
  require 'net/ssh/proxy/command'

  # Define the hostanme of the server to tunnel through
  jump_host = ENV['JUMP_HOST'] || 'jump.library.ucla.edu'

  # Define the port number of the jump host
  jump_port = ENV['JUMP_PORT'] || '31926'

  # Define the username for tunneling
  jump_user = ENV['JUMP_USER'] || ENV['USER']

  # Configure Capistrano to use the jump host as a proxy
  ssh_command = "ssh -p #{jump_port} #{jump_user}@#{jump_host} -W %h:%p"
  set :ssh_options, proxy: Net::SSH::Proxy::Command.new(ssh_command)
end

set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
set :rollbar_env, proc { fetch :stage }
set :rollbar_role, proc { :app }

set :ssh_options, keys: ["ucla_deploy_rsa"] if File.exist?("ucla_deploy_rsa")

set :log_level, :debug
set :bundle_flags, '--deployment'

set :default_env, 'PASSENGER_INSTANCE_REGISTRY_DIR' => '/var/run'

set :keep_releases, 5
set :assets_prefix, "#{shared_path}/public/assets"

SSHKit.config.command_map[:rake] = 'bundle exec rake'

set :branch, ENV['REVISION'] || ENV['BRANCH'] || ENV['BRANCH_NAME'] || 'main'

append :linked_dirs, "log"
append :linked_dirs, "public/assets"
append :linked_dirs, "tmp/pids"
append :linked_dirs, "tmp/cache"
append :linked_dirs, "tmp/sockets"

append :linked_files, ".env.production"
append :linked_files, "config/secrets.yml"

# We have to re-define capistrano-sidekiq's tasks to work with
# systemctl in production. Note that you must clear the previously-defined
# tasks before re-defining them.
Rake::Task["sidekiq:stop"].clear_actions
Rake::Task["sidekiq:start"].clear_actions
Rake::Task["sidekiq:restart"].clear_actions
namespace :sidekiq do
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, :sidekiq
    end
  end
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, :sidekiq
    end
  end
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :sidekiq
    end
  end
end

namespace :californica do
  task :fix_collection_type_labels do
    on roles(:app) do
      execute "cd #{deploy_to}/current; /usr/bin/env bundle exec rake californica:fix_collection_type_labels RAILS_ENV=production"
    end
  end
end

# After the code has been deployed, run db:seed
# This creates the default admin user
after 'deploy:published', 'rails:rake:db:seed'

# After the code has been deployed, run californica:fix_collection_type_labels
# This will fix the translation labels for any collections that are missing them.
after 'deploy:published', 'californica:fix_collection_type_labels'

# Default branch is :main
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
