class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false

      t.integer :owner_id
    end

    add_index :companies, :owner_id
  end
end
