class Quiz < ApplicationRecord
  belongs_to :user, foreign_key: :author_user_id
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :tag_quizzes, dependent: :destroy
  has_many :tags, through: :tag_quizzes

  validates :title, presence: true
  validate :at_least_one_question
  validates :tags, presence: true

  private

  def at_least_one_question
    if questions.reject { |q| q.question.blank? && q.correct_answer.blank? }.empty?
      errors.add(:questions, "は1問から登録できます")
    end
  end

  def self.ransackable_associations(auth_object = nil)
    ["questions", "tags", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["author_user_id", "created_at", "id", "id_value", "questions_count", "title", "updated_at"]
  end
end
