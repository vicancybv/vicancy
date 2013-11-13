class AdminMailer < ActionMailer::Base

  helper :videos

  def message_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "toby@toby.org.uk", subject: 'New enquiry', from: "#{name} <#{email}>")
  end

  def delete_video_email(video_id, user_ip)
    @video = Video.find(video_id)
    @user_ip = user_ip
    mail(to: "toby@toby.org.uk", subject: 'New enquiry', from: "Vicancy <toby@toby.org.uk>")
  end

end



  