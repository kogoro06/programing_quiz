class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.string :title
      t.string :text

      t.timestamps
    end
  end
end
