class MypagesController < ApplicationController
  def show
    @user    = User.find(current_user[:id])
    @profile = Profile.find_by(user_id: current_user[:id])

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
  end

  def edit
  end
  def update
  end
end
