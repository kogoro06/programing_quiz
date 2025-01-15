class Question < ApplicationRecord
  belongs_to :quiz, counter_cache: true
  has_many :choices, dependent: :destroy
  has_one_attached :question_image, dependent: :destroy
  has_one_attached :explanation_image, dependent: :destroy
  accepts_nested_attributes_for :choices, allow_destroy: true

  # 入力があればバリデーションを実行
  validates :question, presence: true, if: :required_question?
  # validate :validate_correct_answer_and_choices



  def required_question?
    quiz&.questions&.first == self
  end

  # questionが入力されている場合に関連バリデーションを有効化
  def validate_correct_answer_and_choices
    if question.present?
      # correct_answerが入力されていない場合のエラーメッセージ
      if correct_answer.blank?
        errors.add(:correct_answer, "正解を入力してください")
      end

      # choicesがすべて入力されていない場合のエラーメッセージ
      if choices.blank? || choices.any? { |choice| choice.choice1.blank? || choice.choice2.blank? || choice.choice3.blank? || choice.choice4.blank? }
        errors.add(:choices, "選択肢をすべて入力してください")
      end
    end
  end
end
