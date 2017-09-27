class CreateAccessLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :access_levels do |t|
      t.integer :user_id
      t.integer :company_id
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
