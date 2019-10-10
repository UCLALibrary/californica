class AddNumberOfChildrenToCsvRow < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_rows, :no_of_children, :integer
  end
end
