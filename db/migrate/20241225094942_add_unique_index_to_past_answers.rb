class AddUniqueIndexToPastAnswers < ActiveRecord::Migration[7.2]
  def change
    add_index :past_answers, [ :question_id, :user_id ], unique: true
  end
end
