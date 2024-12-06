class ContactsController < ApplicationController
  def new
    # ログインユーザーかどうかによって、表示を分ける。
    # deviseの使い方を調べる

    # ゲストユーザーの場合
    @contact = Contact.new
    
    # ログインユーザーの場合
      # ユーザー情報（ユーザー名とメールアドレス）をインスタンス変数に入れる
    #@contact = Contact.new

  end

  def create
    # これでアクセスできる
    contact_params
    
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :title, :text)
  end
end
