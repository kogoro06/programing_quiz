class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :update ]
  before_action :set_user_profile_form, only: [ :edit, :update ]

  def show
    @user    = User.find(params[:user_id])
    @profile = Profile.find_by!(user_id: @user.id)
    # 作成日時を日付に変換
    @quizzes = Quiz.joins(:user)
                  .select('DATE(quizzes.created_at) as created_date,
                            quizzes.title,
                            quizzes.author_user_id,
                            quizzes.questions_count as questions_count,
                            users.name as author_name')
                  .where(author_user_id: @user.id)
                  .page(params[:page])
                  .per(6)
    @quizzes = Quiz.eager_load(:user).where(author_user_id: @user.id).page(params[:page]).per(6)
    @newest_quizzes = @quizzes.order(created_at: :desc).first(6)
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
