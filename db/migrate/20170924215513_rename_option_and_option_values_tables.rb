class RenameOptionAndOptionValuesTables < ActiveRecord::Migration[5.1]
  def change
    rename_table :product_options, :products_options
    rename_table :option_values, :products_option_values
  end
end
