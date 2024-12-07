class AddColumnToContact < ActiveRecord::Migration[7.2]
  def change
    add_column :contacts, :name, :string, null: false
    add_column :contacts, :email, :string, null: false
  end
end
