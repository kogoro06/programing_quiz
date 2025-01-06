class Tag < ApplicationRecord
  has_many :tag_quizzes, dependent: :destroy
  has_many :quizzes, through: :tag_quizzes
end
