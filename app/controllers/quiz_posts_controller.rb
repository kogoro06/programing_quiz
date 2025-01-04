class QuizPostsController < ApplicationController
  before_action :authenticate_user! # ログイン必須

  # 新規投稿ページを表示
  def new
    @quiz = Quiz.new
    # 空のquestionsとchoicesをビルドしてフォームで扱えるようにする
    
    question = @quiz.questions.build
    question.choices.build # 1回だけchoicesを作成
  end

  # クイズを作成して保存
  def create
      @quiz = Quiz.new(quiz_params.merge(author_user_id: current_user.id))
    if @quiz.save
      redirect_to quiz_path(@quiz), notice: 'クイズを投稿しました！'
    else
      flash.now[:alert] = 'クイズの投稿に失敗しました。'
      render :new
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      :title,
      :author_user_id,
      questions_attributes: [
        :id,
        :question,
        :correct_answer,
        :answer_source,
        :explanation,
        :_destroy,
        choices_attributes: [
          :id,
          :choice1,
          :choice2,
          :choice3,
          :choice4,
          :_destroy
        ]
      ]
    )
  end
end
