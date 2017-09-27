class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.text :description
      t.string :image_url
      t.integer :company_id
      t.integer :price_cents

      t.timestamps
    end

    add_index :products, :company_id
  end
end
