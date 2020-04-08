# frozen_string_literal: true

namespace :californica do
  task delete_work: [:environment] do
    delete_with_children(Work.find(ENV.fetch('DELETE_WORK_ID')))
    puts('Done!')
  end
end

def delete_with_children(record)
  record.members.each do |child|
    delete_with_children(child)
  end
  record&.destroy&.eradicate
  Hyrax.config.callback.run(:after_destroy, record.id, User.batch_user)
  puts("Deleted #{record.class} #{record.ark}")
end
