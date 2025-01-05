class QuizPostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @quiz = Quiz.new
    # 空のquestionsとchoicesをビルドしてフォームで扱えるようにする
      10.times do
      question = @quiz.questions.build
      question.choices.build # 1回だけchoicesを作成
    end
  end

  def create
    @quiz = Quiz.new(quiz_params.merge(author_user_id: current_user.id))
    if @quiz.save
      redirect_to quiz_path(@quiz), notice: 'クイズを投稿しました！'
    else
      flash.now[:alert] = 'クイズの投稿に失敗しました。'
      @page = (params[:page] || 1).to_i
      @current_question = @quiz.questions[@page - 1]
      render :new
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      :title,
      questions_attributes: [
        :id,
        :question,
        :correct_answer,
        :answer_source,
        :explanation,
        :_destroy,
        :question_image,
        :explanation_image,
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
