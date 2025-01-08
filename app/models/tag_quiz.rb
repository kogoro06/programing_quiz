class TagQuiz < ApplicationRecord
  belongs_to :quiz
  belongs_to :tag
end
