class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :author_user, null: false, foreign_key: { to_table: :users }
      t.text :question
      t.json :choices, null: false
      t.integer :correct_answer, null: false
      t.string :answer_source
      t.text :explanation

      t.timestamps
    end
  end
end
