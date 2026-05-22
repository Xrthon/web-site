class CreateUserProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :display_name
      t.string :phone
      t.string :avatar_url
      t.string :language
      t.string :timezone
      t.string :country
      t.string :city

      t.timestamps
    end
  end
end
