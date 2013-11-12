class ContactMailer < ActionMailer::Base

  def message_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "toby@toby.org.uk", subject: 'New enquiry', from: "#{name} <#{email}>")
  end

end



  