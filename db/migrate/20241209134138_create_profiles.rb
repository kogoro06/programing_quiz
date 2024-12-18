class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :avatar_url
      t.string :bio
      t.string :studying_languages
      t.string :github_link
      t.string :x_link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
