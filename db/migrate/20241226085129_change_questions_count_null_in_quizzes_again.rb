class ChangeQuestionsCountNullInQuizzesAgain < ActiveRecord::Migration[7.2]
  def change
    change_column_null :quizzes, :questions_count, false
  end
end
