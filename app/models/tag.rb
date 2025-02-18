class Tag < ApplicationRecord
  has_many :tag_quizzes, dependent: :destroy
  has_many :quizzes, through: :tag_quizzes
  def data_color
    case id
    when 1 then "bg-html"
    when 2 then "bg-css"
    when 3 then "bg-js"
    when 4 then "bg-ruby"
    when 5 then "bg-git"
    when 6 then "bg-error"
    when 7 then "bg-react"
    when 8 then "bg-java"
    when 9 then "bg-laravel"
    end
  end
end
