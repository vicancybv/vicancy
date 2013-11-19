class AdminMailer < ActionMailer::Base

  RECIPIENT = "loet@vicancy.com"

  helper :videos

  def message_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: RECIPIENT, subject: '[Vicancy] New enquiry', from: "#{name} <#{email}>")
  end

  def edit_video_email(video, user_ip)
    @video = video
    @user_ip = user_ip
    mail(to: RECIPIENT, subject: '[Vicancy] Video edits request', from: "Vicancy <info@vicancy.com>")
  end

  def delete_video_email(video, user_ip)
    @video = video
    @user_ip = user_ip
    mail(to: RECIPIENT, subject: '[Vicancy] Delete video request', from: "Vicancy <info@vicancy.com>")
  end

end



  