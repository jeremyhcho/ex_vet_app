class CreateProductsVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :products_variants do |t|
      t.integer :product_id
      t.integer :price_cents, default: 0

      t.timestamps
    end

    add_index :products_variants, :product_id
  end
end
