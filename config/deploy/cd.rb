# frozen_string_literal: true
# Deploy to continuous deployment server
server 'cd-ucla.curationexperts.com', user: 'deploy', roles: [:web, :app, :db]
