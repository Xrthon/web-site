class AddThemeColorToUserProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :user_profiles, :theme_color, :string
  end
end
