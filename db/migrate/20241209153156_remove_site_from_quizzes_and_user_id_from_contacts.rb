class RemoveSiteFromQuizzesAndUserIdFromContacts < ActiveRecord::Migration[7.2]
  def change
    # quizzes テーブルから site カラムを削除
    remove_column :quizzes, :site, :string

    # contacts テーブルから user_id カラムを削除
    remove_column :contacts, :user_id, :bigint
  end
end
