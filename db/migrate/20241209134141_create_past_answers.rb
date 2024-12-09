class CreatePastAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :past_answers do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :answer_content
      t.boolean :answer_result

      t.timestamps
    end
  end
end
