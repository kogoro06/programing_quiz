class RemoveAuthorUserIdFromQuestions < ActiveRecord::Migration[7.2]
  def change
    remove_column :questions, :author_user_id, :bigint
  end
end
