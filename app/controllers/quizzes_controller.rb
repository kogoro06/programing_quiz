class QuizzesController < ApplicationController
  before_action :set_quiz, only: [ :destroy ]

  def destroy
    @quiz.destroy!
    redirect_to "/", notice: "クイズを削除しました。"
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id]) # これで@quizを設定するカ
  end
end
