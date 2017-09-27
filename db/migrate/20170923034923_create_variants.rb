class CreateVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :variants do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.string :image_url
      t.integer :price_cents
      t.integer :product_id

      t.timestamps
    end

    add_index :variants, :product_id
  end
end
