class ProfilesController < ApplicationController
  before_action :set_user_profile_form, only: [ :edit, :update ]

  def show
    begin
      @user    = User.find(current_user[:id])
      @profile = Profile.find_by!(user_id: current_user[:id])
      # 作成日時を日付に変換
      @quizzes = Quiz.joins(:user)
                    .select('DATE(quizzes.created_at) as created_date,
                              quizzes.title,
                              quizzes.author_user_id,
                              quizzes.questions_count as questions_count,
                              users.name as author_name')
                    .where(author_user_id: current_user[:id])
                    .page(params[:page])
                    .per(6)
    rescue => e
      # FIXME: トップページと重複しているので後日リファクタリングする
      @quizzes = Quiz.eager_load(:user).all
      @newest_quizzes = @quizzes.order(created_at: :desc).first(6)
      flash.now[:alert] = "ログインしてください"
      render template: "quiz_posts/index", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user_profile_form.save(user_profile_form_params)
      redirect_to user_profile_path(current_user[:id]), flash: { notice: "プロフィールを更新しました" }
    else
      flash[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_profile_form_params
    params.require(:user_profile_form).permit(:bio, :studying_languages, :x_link, :github_link, :name)
  end

  def set_user_profile_form
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @user_profile_form = UserProfileForm.new(@user, @profile)
  end
end
