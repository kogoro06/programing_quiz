class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.string :title, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
