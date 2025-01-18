class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.errors.any? # もしエラーがあれば
        flash[:alert] = I18n.t("devise.registrations.failure") # カスタムメッセージを設定
      end
    end
  end

  protected

  # ユーザー登録後のリダイレクト先を指定（親クラスにも同じ名前のメソッド名があり、ここでオーバーライドしている）
  def after_sign_up_path_for(resource)
    edit_user_profile_path(resource)
  end
end
