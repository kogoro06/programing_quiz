class ReviewController < ApplicationController
  def create
    # レビュー情報を保存
    @review = Review.new(review_params)
    if @review.save
      flash[:notice] = "レビューを保存しました"
      redirect_to root_path
    else
      flash[:alert] = "レビューの保存に失敗しました"
      redirect_to root_path
    end
  end

  private

  def review_params
    p "params = #{params}"
    params.permit(:user_id, :quiz_id, :score)
  end
end
