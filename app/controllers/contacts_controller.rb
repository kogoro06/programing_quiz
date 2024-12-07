class ContactsController < ApplicationController
  def new
    if user_signed_in?
      @contact = Contact.new(name: current_user.name, email: current_user.email)
    else
      @contact = Contact.new()
    end
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
