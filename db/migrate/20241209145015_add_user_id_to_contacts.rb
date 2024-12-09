class AddUserIdToContacts < ActiveRecord::Migration[7.2]
  def change
    add_column :contacts, :user_id, :bigint
  end
end
