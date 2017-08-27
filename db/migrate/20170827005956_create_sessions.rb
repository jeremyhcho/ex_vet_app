class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :sessions, :user_id
    add_index :sessions, :token, unique: true
  end
end
