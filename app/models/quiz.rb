class Quiz < ApplicationRecord
  belongs_to :user, foreign_key: :author_user_id
  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true
  validate :at_least_one_question

  private

  def at_least_one_question
    if questions.reject { |q| q.question.blank? && q.correct_answer.blank? }.empty?
      errors.add(:questions, "クイズには少なくとも1問の有効な質問が必要です")
    end
  end
end
