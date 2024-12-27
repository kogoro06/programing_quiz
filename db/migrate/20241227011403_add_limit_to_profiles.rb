class AddLimitToProfiles < ActiveRecord::Migration[7.2]
  def change
    change_column :profiles, :bio,                :string, limit: 250
    change_column :profiles, :studying_languages, :string, limit: 250
    change_column :profiles, :github_link,        :string, limit: 250
    change_column :profiles, :x_link,             :string, limit: 250
  end
end
