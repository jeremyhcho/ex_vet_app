class CreateProductOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :product_options do |t|
      t.string :option_name
      t.integer :product_id

      t.timestamps
    end
  end
end
