# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def contact_test
    contact = Contact.new(title: "お問い合わせ", text: "問い合わせメッセージ")

    ContactMailer.send_email_to_manager(contact)
  end
end
