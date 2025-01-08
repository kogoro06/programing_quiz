class ChangePastAnswersToUseQuestionId < ActiveRecord::Migration[7.0]
  def change
    # quiz_id を削除して question_id を追加
    remove_reference :past_answers, :quiz, foreign_key: true
    add_reference :past_answers, :question, null: false, foreign_key: true
  end
end
