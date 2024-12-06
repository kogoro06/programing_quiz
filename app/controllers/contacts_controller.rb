class ContactsController < ApplicationController
  def new
    # ログイン中ユーザーなら、ログイン情報やメールアドレスを渡すよう改修する
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_email_to_manager(@contact).deliver_now
      flash[:notice] = "お問い合わせが送信されました。"
      redirect_to root_path
    else
      flash.now[:alert] = "入力内容に不備があります。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :title, :text)
  end
end
