class Question < ApplicationRecord
  belongs_to :quiz, counter_cache: true
  has_many :choices
  accepts_nested_attributes_for :choices, allow_destroy: true

  # 入力があればバリデーションを実行
  validates :question, presence: true, unless: :optional_question?
  validates :correct_answer, presence: true, unless: :optional_question?

  # 必須でない質問をスキップ
  def optional_question?
    question.blank? && correct_answer.blank?
  end
end
