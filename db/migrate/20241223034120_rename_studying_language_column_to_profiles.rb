class RenameStudyingLanguageColumnToProfiles < ActiveRecord::Migration[7.2]
  def change
    rename_column :profiles, :studying_language, :studying_languages
    rename_column :profiles, :x_links, :x_link
    rename_column :profiles, :github_links, :github_link
  end
end
