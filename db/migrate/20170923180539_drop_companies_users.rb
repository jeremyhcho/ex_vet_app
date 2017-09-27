class DropCompaniesUsers < ActiveRecord::Migration[5.1]
  def change
    drop_table :companies_users
  end
end
