class ChangeColorColumnTypeInTags < ActiveRecord::Migration[7.0]
  def change
    change_column :tags, :color, :string, null: false
  end
end
