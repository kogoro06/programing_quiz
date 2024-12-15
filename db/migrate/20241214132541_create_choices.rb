class CreateChoices < ActiveRecord::Migration[7.2]
  def change
    create_table :choices do |t|
      t.string :choice1, null: false
      t.string :choice2, null: false
      t.string :choice3, null: false
      t.string :choice4, null: false
      t.references :question, null: false, foreign_key: true
      t.timestamps
    end
  end
end
