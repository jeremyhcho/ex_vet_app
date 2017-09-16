class AddRememberMeToSession < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :remember_me, :string
  end
end
