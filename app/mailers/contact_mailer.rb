class ContactMailer < ApplicationMailer
  def send_email_to_manager(contact)
    @contact_notification = contact
    mail(
      from: Rails.application.credentials.application_email,
      to:   Rails.application.credentials.application_email,
      subject: "お問い合わせ通知",
    )
  end
end
