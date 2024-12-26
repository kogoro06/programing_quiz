class MypagesController < ApplicationController
  def show
    @user    = User.find(current_user[:id])
    @profile = Profile.find_by(user_id: current_user[:id])

    # 作成日時を日付に変換
    @quizzes = Quiz.joins(:user)
                   .select('DATE(quizzes.created_at) as created_date,
                            quizzes.title,
                            quizzes.author_user_id,
                            users.name as author_name')
                   .where(author_user_id: current_user[:id])
                   .page(params[:page])
                   .per(2)
    
    # TODO: （たかのタスク）タグ機能実装後、タグの表示を実装する
    # TODO: （たかのタスク）すーさんに問題数をテーブルに保存してもらえるように依頼する。OKであれば、quizテーブルから問題数を取得する
    # TODO: （たかのタスク）ページネーションの実装
    # TODO: （たかのタスク）ビューにもTODOを残せるように実装する
    # TODO: （たかのタスク）必要なファイルだけコミットするようにする

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end
  def update
  end
end
