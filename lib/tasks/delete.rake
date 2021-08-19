# frozen_string_literal: true

namespace :californica do
  task delete_work: [:environment] do
    Californica::Deleter.new(ENV.fetch('DELETE_WORK_ID')).delete_with_children
    puts('Done!')
  end
end
