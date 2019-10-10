# frozen_string_literal: true

class ReindexItemJob < ApplicationJob
  queue_as :default

  def perform(item_ark, csv_import_id: nil)
    item = Collection.find_by_ark(item_ark) || Work.find_by_ark(item_ark) || ChildWork.find_by_ark(item_ark)
    raise(ArgumentError, "No such item: #{item_ark}.") unless item

    # Apply page orderings if importing Works from a CSV
    if csv_import_id && item.is_a?(Work)
      page_orderings = PageOrder.where(parent: Ark.ensure_prefix(item_ark))
      ordered_arks = page_orderings.sort_by(&:sequence)
      item.ordered_members = ordered_arks.map { |b| ChildWork.find_by_ark(b.child) }
    end

    enable_recalculate_size(item)
    item.save

    CreateManifestJob.perform_later(item_ark) unless item.is_a? Collection
  end

  def deduplication_key
    "ReindexItemJob-#{arguments[0]}"
  end

  def enable_recalculate_size(item)
    item.recalculate_size = true
  rescue NoMethodError
    nil
  end
end
