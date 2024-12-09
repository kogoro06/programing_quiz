class CreateQuizzes < ActiveRecord::Migration[6.1]
  def change
    create_table :quizzes do |t|
      t.references :author_user, null: false, foreign_key: { to_table: :users }
      t.string :site

      t.timestamps
    end
  end
end
