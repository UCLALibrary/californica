# frozen_string_literal: true
module Californica
  class OrderChildWorksService
    def initialize(order_children_object)
      @order_children_object = order_children_object
      @work_ark = order_children_object.ark
    end

    def order
      log_start

      page_orderings = PageOrder.where(parent: Ark.ensure_prefix(@work_ark))
      ordered_arks = page_orderings.sort_by(&:sequence)
      work = Work.find_by_ark(Ark.ensure_prefix(@work_ark))

      work.ordered_members = ordered_arks.map { |b| ChildWork.find_by_ark(b.child) }
      work.save

      log_end
    rescue => e
      log_error(e)
    end

    private

      def log_start
        @start_time = Time.zone.now
        @order_children_object.status = 'in progress'
        @order_children_object.start_time = @start_time
        @order_children_object.save
      end

      def log_end
        @order_children_object.status = 'complete'
        end_time = Time.zone.now
        @order_children_object.end_time = end_time
        @order_children_object.elapsed_time = end_time - @start_time
        @order_children_object.save
      end

      def log_error(e)
        @order_children_object.status = 'error'
        @order_children_object.error_messages << e
        @order_children_object.save
      end
  end
end
