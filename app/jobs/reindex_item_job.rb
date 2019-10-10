# frozen_string_literal: true

class ReindexItemJob < ApplicationJob
  queue_as :default

  def perform(item_ark, csv_import_id: nil)
    item = Collection.find_by_ark(item_ark) || Work.find_by_ark(item_ark) || ChildWork.find_by_ark(item_ark)
    raise(ArgumentError, "No such item: #{item_ark}.") unless item
    set_recalculate_size(item)
    item.save
  end

  def deduplication_key
    "ReindexItemJob-#{arguments[0]}"
  end

  def set_recalculate_size(item)
    item.recalculate_size = true
  rescue NoMethodError
    nil
  end

end
