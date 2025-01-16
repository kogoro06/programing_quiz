class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :update ]
  before_action :set_user_profile_form, only: [ :edit, :update ]

  def show
    @user    = User.find(params[:user_id])
    @profile = Profile.find_by!(user_id: @user.id)
    @quizzes = Quiz.eager_load(:user).where(author_user_id: @user.id).page(params[:page]).per(6)
  end

  def edit
    user_inspections(@user)
  end

  def update
    user_inspections(@user)
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

  def user_inspections(user)
    if current_user != user
      redirect_to user_profile_path(user), flash: { alert: "他のユーザーのプロフィールは編集できません" }
    end
  end
end
