class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.datetime :from, null: false
      t.datetime :to, null: false
      t.string :title, null: false
      t.text :description
      t.integer :location_id
      t.integer :creator_id
      t.integer :company_id

      t.timestamps
    end

    add_index :appointments, :location_id
  end
end
