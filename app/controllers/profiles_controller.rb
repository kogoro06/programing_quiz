class ProfilesController < ApplicationController
  before_action :set_user_profile_form, only: [ :edit, :update ]

  def show
    @user = current_user
    @profile = Profile.find_or_create_by(user_id: current_user.id) do |profile|
      # デフォルト値を設定（必要に応じて変更）
      profile.bio = "まだ自己紹介がありません。"
      profile.studying_languages = "未設定"
      profile.github_link = "https://github.com/"
      profile.x_link = "https://x.com/"
    end

    @quizzes = Quiz.joins(:user) # INNER JOIN で users テーブルを含める
                   .includes(:tags) # タグを事前ロード
                   .select("quizzes.*, DATE(quizzes.created_at) as created_date, users.name as author_name")
                   .where(author_user_id: current_user.id)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(6)
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
    params.require(:user_profile_form).permit(:bio, :studying_languages, :x_link, :github_link, :name, :user_icon)
  end

  def set_user_profile_form
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @user_profile_form = UserProfileForm.new(@user, @profile)
  end
end
