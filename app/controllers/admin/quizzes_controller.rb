class Admin::QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def destroy
    @quiz.destroy
    redirect_to "/", notice: "クイズを削除しました。"
  end

  private

  def authorize_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end
end
