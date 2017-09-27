class CreateOptionValues < ActiveRecord::Migration[5.1]
  def change
    create_table :option_values do |t|
      t.string :option_value, null: false
      t.integer :product_option_id

      t.timestamps
    end
  end
end
