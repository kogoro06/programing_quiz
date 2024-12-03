class ContactMailer < ApplicationMailer
  def contact_message(contact)
    @contact = contact
    mail(to: 'taku112ne@gmail.com', subject: '新しいお問い合わせがあります（サンプルメール）')
  
  end
end
