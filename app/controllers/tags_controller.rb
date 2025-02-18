class TagsController < ApplicationController
  before_action :set_tag, only: [ :show ]

  def index
    set_tags
  end

  def show
    @quizzes = @tag.quizzes.eager_load(:user, :tags)
                   .select("quizzes.created_at, quizzes.title, quizzes.author_user_id, quizzes.questions_count, users.name as author_name")
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(6)
    @newest_quizzes = Quiz.includes(:tags).order(created_at: :desc).first(6)
    set_tags
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_tags
    @tags = Tag.all
  end
end
