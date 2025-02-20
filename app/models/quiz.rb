class Quiz < ApplicationRecord
  belongs_to :user, foreign_key: :author_user_id
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :tag_quizzes, dependent: :destroy
  has_many :tags, through: :tag_quizzes

  validates :title, presence: true
  validate :at_least_one_question
  validates :tags, presence: true

  before_save :set_name_hiragana

  private

  def at_least_one_question
    if questions.reject { |q| q.question.blank? && q.correct_answer.blank? }.empty?
      errors.add(:questions, "は1問から登録できます")
    end
  end

  def set_name_hiragana
    return if title.blank?
    require "moji"

    # まず全ての文字を正規化
    normalized = title.tr("Ａ-Ｚａ-ｚ０-９", "A-Za-z0-9")  # 全角英数を半角に
                     .tr("！-～", "!-~")                    # 全角記号を半角に
                     .tr("。、", "｡､")                      # 句読点を半角に
    
    # カタカナをひらがなに変換（濁点などの正規化も含む）
    self.name_hiragana = normalized.tr("ァ-ン", "ぁ-ん")
                                 .tr("ｧ-ﾝ", "ぁ-ん")       # 半角カタカナ対応
  rescue => e
    Rails.logger.error "Failed to generate hiragana: #{e.message}"
    self.name_hiragana = title
  end

  def self.ransackable_associations(auth_object = nil)
    [ "questions", "tags", "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "author_user_id", "created_at", "id", "id_value", "questions_count", "title", "updated_at" ]
  end
end
