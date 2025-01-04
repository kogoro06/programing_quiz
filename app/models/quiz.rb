class Quiz < ApplicationRecord
  belongs_to :user, foreign_key: :author_user_id
  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true
  validates :questions, length: { minimum: 1, maximum: 10 }
end
