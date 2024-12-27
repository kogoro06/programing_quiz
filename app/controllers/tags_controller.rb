class TagsController < ApplicationController
  def index
  end

  def show
    @quizzes = Tag.find(params[:id]).quizzes.eager_load(:user, :tags)
  end
end
