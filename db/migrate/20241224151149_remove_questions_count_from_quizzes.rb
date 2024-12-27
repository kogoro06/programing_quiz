class RemoveQuestionsCountFromQuizzes < ActiveRecord::Migration[7.2]
  def change
    remove_column :quizzes, :questions_count, :integer
  end
end
