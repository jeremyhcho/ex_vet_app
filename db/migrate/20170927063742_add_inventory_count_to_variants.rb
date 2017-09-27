class AddInventoryCountToVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :variants, :integer, :inventory_count
  end
end
