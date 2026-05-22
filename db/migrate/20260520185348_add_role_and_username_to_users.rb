class AddRoleAndUsernameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :role, foreign_key: true

    add_column :users, :username, :string
    add_column :users, :active, :boolean, default: true, null: false

    add_index :users, :username, unique: true
  end
end