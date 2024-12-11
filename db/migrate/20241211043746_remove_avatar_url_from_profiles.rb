class RemoveAvatarUrlFromProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :avatar_url, :string
  end
end
