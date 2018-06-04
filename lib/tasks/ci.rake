# frozen_string_literal: true
task ci: ['rubocop', 'spec_with_server']

unless Rails.env.production?
  require 'solr_wrapper/rake_task'

  task :spec_with_server do
    with_server 'test' do
      Rake::Task['spec'].invoke
    end
  end
end
