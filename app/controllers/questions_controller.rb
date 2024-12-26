class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @choices = Choice.where(question_id: @question.id)
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
  @choices = Choice.where(question_id: @question.id)
  @past_answer = PastAnswer.find_by(question_id: @question.id, user_id: current_user.id)

  @next_question = Question.where("id > ? AND quiz_id = ?", @question.id, @question.quiz_id).first
  @has_next_question = @next_question.present?
end
end
