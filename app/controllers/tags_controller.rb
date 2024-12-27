class TagsController < ApplicationController
  def index
  end

  def show
    @tag = Tag.find(params[:id])
    @quizzes = @tag.quizzes.eager_load(:user, :tags)
  end
end
