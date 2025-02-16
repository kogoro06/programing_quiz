class Question < ApplicationRecord
  belongs_to :quiz, counter_cache: true
  has_many :choices, dependent: :destroy
  has_one_attached :question_image, dependent: :destroy
  has_one_attached :explanation_image, dependent: :nullify
  accepts_nested_attributes_for :choices, allow_destroy: true
  has_many :past_answers, dependent: :destroy

  # 入力があればバリデーションを実行
  validates :question, presence: true, if: :required_question?
  validate :validate_correct_answer_and_choices
  # 必要な場合に `question` を必須にする
  validates :question, presence: true, if: :question_needed?

  # `question` がある場合は `correct_answer` と `choices` も必須にする
  validates :correct_answer, presence: true, if: -> { question.present? }
  validates :choices, presence: true, if: -> { question.present? }



  def required_question?
    quiz&.questions&.first == self
  end

  # questionが入力されている場合に関連バリデーションを有効化
  def validate_correct_answer_and_choices
    if question.present?
      # correct_answerが入力されていない場合のエラーメッセージ
      if correct_answer.blank?
        errors.add(:correct_answer, "を入力してください")
      end

      # choicesがすべて入力されていない場合のエラーメッセージ
      if choices.blank? || choices.any? { |choice| choice.choice1.blank? || choice.choice2.blank? || choice.choice3.blank? || choice.choice4.blank? }
        errors.add(:choices, "をすべて入力してください")
      end
    end
  end

  def question_needed?
    # `correct_answer` や `choices` のいずれかが入力されている場合は `question` を必須にする
    correct_answer.present? || choices.any? { |c| c.choice1.present? || c.choice2.present? || c.choice3.present? || c.choice4.present? }
  end
end
