# frozen_string_literal: true
server 'californica-dev.library.ucla.edu', user: 'deploy', roles: [:web, :app, :db]
# Capistrano passenger restart isn't working consistently,
# so restart apache2 after a successful deploy, to ensure
# changes are picked up.
namespace :deploy do
  after :finishing, :restart_apache do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :httpd
    end
  end
end
