class AddNameHiraganaToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :name_hiragana, :string
    add_index :quizzes, :name_hiragana
  end
end
