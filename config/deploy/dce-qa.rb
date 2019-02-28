# frozen_string_literal: true
# Deploy to continuous deployment server
server 'californica-qa.curationexperts.com', user: 'deploy', roles: [:web, :app, :db]
# Capistrano passenger restart isn't working consistently,
# so restart apache2 after a successful deploy, to ensure
# changes are picked up.
namespace :deploy do
  after :finishing, :restart_apache do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :apache2
    end
  end
end
