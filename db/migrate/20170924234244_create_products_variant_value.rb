class CreateProductsVariantValue < ActiveRecord::Migration[5.1]
  def change
    create_table :products_variant_values do |t|
      t.integer :variant_id
      t.integer :option_value_id

      t.timestamps
    end

    add_index :products_variant_values, :variant_id
    add_index :products_variant_values, :option_value_id
  end
end
