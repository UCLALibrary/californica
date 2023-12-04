# frozen_string_literal: true

namespace :californica do
  task delete_work: [:environment] do
    Californica::Deleter.new(id: ENV.fetch('DELETE_WORK_ID')).delete_with_children
    puts('Done!')
  end

  task delete_collection: [:environment] do
    begin
      deletion_successful = Californica::Deleter.new(id: ENV.fetch('DELETE_COLLECTION_ID')).delete_collection_with_works
      puts deletion_successful ? 'Deletion completed successfully!' : 'Deletion skipped for some items.'
    rescue => e
      puts "An error occurred: #{e.message}"
    end
    puts('Done!')
  end

  task delete_all_child_works: [:environment] do
    DeleteAllChildWorksJob.perform_later unless Flipflop.child_works?
  end
end
