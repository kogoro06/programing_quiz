class ChangeColorToBeStringInTags < ActiveRecord::Migration[6.0]
  def up
    change_column :tags, :color, :string, null: false
  end

  def down
    change_column :tags, :color, :json, null: false
  end
end
