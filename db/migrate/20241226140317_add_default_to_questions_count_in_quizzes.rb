class AddDefaultToQuestionsCountInQuizzes < ActiveRecord::Migration[7.2]
  def change
    change_column_default :quizzes, :questions_count, from: nil, to: 0
  end
end
