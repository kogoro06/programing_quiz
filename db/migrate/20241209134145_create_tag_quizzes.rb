class CreateTagQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_quizzes do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
