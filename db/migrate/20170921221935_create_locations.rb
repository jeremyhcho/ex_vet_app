class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :country
      t.string :state
      t.string :city
      t.string :address
      t.string :zip
      t.integer :company_id

      t.timestamps
    end
  end
end
