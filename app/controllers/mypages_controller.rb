class MypagesController < ApplicationController
  def show
    # ログインしてある状態でマイページにアクセスする（ログインしていないとルーティングエラーになる）
    # （未検証）今の段階では、ログインしていればshowを出すというだけで、他の人のマイページも見れてしまいそう
    @current_user = current_user
    # @ = current_user[:id]
    @profile = Profile.find_by(user_id: current_user[:id])
    # profileモデルができてない

    # 21:19:19 web.1  | [7] pry(#<MypagesController>)> current_user
# => #<User id: 1, email: [FILTERED], name: "admin_user1", role: "admin", created_at: "2024-12-14 18:02:16.515552000 +0900", updated_at: "2024-12-14 18:02:16.515552000 +0900">

  end
  def edit
  end
  def update
  end
end
