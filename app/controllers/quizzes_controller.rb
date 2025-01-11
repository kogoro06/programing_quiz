class QuizzesController < ApplicationController
  def show
    @quiz = Quiz.eager_load(:user, :questions, :tags).find(params[:id])
    @questions = @quiz.questions
  end
end
