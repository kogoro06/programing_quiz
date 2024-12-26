class QuizController < ApplicationController
  def new
    @quiz = Quiz.new
  end

  
end
