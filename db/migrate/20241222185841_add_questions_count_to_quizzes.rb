class AddQuestionsCountToQuizzes < ActiveRecord::Migration[7.2]
  def change
    add_column :quizzes, :questions_count, :integer
  end
end
