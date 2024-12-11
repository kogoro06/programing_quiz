class ChangeTextColumnTypeInContacts < ActiveRecord::Migration[7.0]
  def up
    change_column :contacts, :text, :text, null: false
  end

  def down
    change_column :contacts, :text, :string, null: false
  end
end
