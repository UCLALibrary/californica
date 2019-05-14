class CreatePageOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :page_orders do |t|
      t.string :parent
      t.string :child
      t.integer :sequence

      t.timestamps
    end
  end
end
