class AddQuizIdToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :quiz_id, :bigint, null: false
  end
end
