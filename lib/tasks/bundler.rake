namespace :bundler do
  desc "Install latest version of bundler"
  task :gem_install do
    exec "bundle update --bundler"
  end
end
