class ContactMailer < ApplicationMailer
  def send_email_to_manager(contact)
    @contact_notification = contact
    mail(
      from: 'taku112ne@gmail.com',  # 問い合わせ送信者。一旦ハードコーディングして、問い合わせフォームができ次第フォームからの流れを確認。
      to:   'questionprograming@gmail.com', # 管理者用Email
      subject: 'お問い合わせ通知',
    )
  end
end
