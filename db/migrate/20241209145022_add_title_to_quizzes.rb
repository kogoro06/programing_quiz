class AddTitleToQuizzes < ActiveRecord::Migration[7.2]
  def change
    add_column :quizzes, :title, :string
  end
end
