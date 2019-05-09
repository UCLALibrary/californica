# frozen_string_literal: true
namespace :californica do
  namespace :read_only do
    desc 'Turn ON read-only mode (to make backups)'
    task on: [:environment] do
      Hyrax::Feature.where(key: "read_only").all.each.map(&:destroy!)
      Hyrax::Feature.create(key: "read_only", enabled: true)
      puts "The system is now in read-only mode"
    end

    desc 'Turn OFF read-only mode (when backups are complete)'
    task off: [:environment] do
      Hyrax::Feature.where(key: "read_only").all.each.map(&:destroy!)
      puts "Read-only mode is now OFF"
    end
  end
end
