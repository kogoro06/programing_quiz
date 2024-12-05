class ContactMailer < ApplicationMailer
  def send_email_to_manager(contact)
    @contact_notification = contact
    mail(
      from: 'system@example.com',  # Railsの予定
      to:   'manager@example.com', # 管理者用Email
      subject: 'お問い合わせ通知'
    )
  end
end
