class QuizPostsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @quiz = Quiz.new
    @question = Question.new
  end

  def create
    Rails.logger.debug "Received params: #{params.inspect}"
    @quiz = Quiz.new(quiz_params)
    @question = Question.new(question_params)
    if @quiz.save
      # 保存に成功した場合の処理
      redirect_to quiz_posts_path, notice: "クイズが作成されました。"
    else
      # 保存に失敗した場合の処理
      render :new
    end
  end

  def edit
  end

  def update
  end

  def bookmarks
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title)
  end

  def question_params
    params.require(:question).permit(:question)
  end
end
