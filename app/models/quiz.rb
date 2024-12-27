class Quiz < ApplicationRecord
  belongs_to :user, foreign_key: :author_user_id
  has_many :questions
  has_many :tag_quizzes, dependent: :destroy
  has_many :tags, through: :tag_quizzes
end
