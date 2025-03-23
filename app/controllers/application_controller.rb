class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :set_user
  before_action :set_profile
  before_action :set_search

  before_action :configure_permitted_parameters, if: :devise_controller?

  def get_popular_quizzes
    popular_quizzes_ids = PastAnswer.joins(question: :quiz).where(created_at: 1.week.ago..Time.current).group(:quiz_id).count.sort_by { |_, v| -v }.first(5).map(&:first)
    popular_quizzes = Quiz.eager_load(:user, :tags).where(id: popular_quizzes_ids)
    return popular_quizzes
  end

  private

  def page_title(title = "")
    base_title = "Programming Question"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def set_user
    @user = current_user
  end

  def set_profile
    @profile = current_user&.profile if user_signed_in?
  end

  def set_search
    @q = Quiz.ransack(params[:q])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
