class RenameOptionForeignKeysAndAddIndex < ActiveRecord::Migration[5.1]
  def change
    rename_column :products_option_values, :product_option_id, :option_id
    add_index :products_option_values, :option_id
    add_index :products_options, :product_id
  end
end
