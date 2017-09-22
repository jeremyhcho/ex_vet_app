class CreateCompaniesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :companies_users do |t|
      t.integer :company_id
      t.integer :user_id
    end

    add_index :companies_users, [:company_id, :user_id], unique: true
  end
end
