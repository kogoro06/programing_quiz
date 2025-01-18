class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :new ] # ログインが必要なアクションを設定

  def new
  end

  def show
    begin
      @question = Question.find(params[:id])
      @quiz = @question.quiz
      @choices = Choice.where(question_id: @question.id)
      choices_adjust(@choices)
      @quiz = @question.quiz
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Question not found: #{e.message}")
      flash[:alert] = "指定された質問が見つかりませんでした。"
      redirect_to root_path
    end
  end

  def create
  end

  def create_result
    @question = Question.find(params[:question_id])
    user_answer = params[:answer]
    correct_answer = @question.correct_answer
    is_correct = (user_answer.to_s == correct_answer.to_s)

    past_answer = PastAnswer.find_or_initialize_by(
      question_id: @question.id,
      user_id: current_user.id
    )
    past_answer.update!(
      answer_content: user_answer,
      answer_result: is_correct
    )
  end

  def result
    @question = Question.find(params[:id])
    @quiz = @question.quiz
    @choices = Choice.where(question_id: @question.id)
    @quiz = @question.quiz

    @past_answer = PastAnswer.find_by(question_id: @question.id, user_id: current_user.id)
    unless @past_answer
      flash[:alert] = "回答履歴が見つかりませんでした。"
      redirect_to root_path and return
    end

    @next_question = Question.where("id > ? AND quiz_id = ?", @question.id, @question.quiz_id).first
    @has_next_question = @next_question.present?
  end

  private

  def authenticate_user!
    unless user_signed_in? # ユーザーがログインしているかを確認
      flash[:alert] = "ログインが必要です。"
      redirect_to new_user_session_path
    end
  end

  def choices_adjust(choices)
    choices.each do |choice|
      if choice.choice1.include?("<")
        choice.choice1.gsub!("<", "＜").gsub!(">", "＞")
      end
      if choice.choice2.include?("<")
        choice.choice2.gsub!("<", "＜").gsub!(">", "＞")
      end
      if choice.choice3.include?("<")
        choice.choice3.gsub!("<", "＜").gsub!(">", "＞")
      end
      if choice.choice4.include?("<")
        choice.choice4.gsub!("<", "＜").gsub!(">", "＞")
      end
    end
  end
end
