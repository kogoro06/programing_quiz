class ChangeQuestionsCountNullInQuizzes < ActiveRecord::Migration[7.2]
  def change
    change_column_null :quizzes, :questions_count, true
  end
end
