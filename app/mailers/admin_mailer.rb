class AdminMailer < ActionMailer::Base

  RECIPIENT = "support@vicancy.com"

  helper :videos

  def message_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: RECIPIENT, subject: '[Vicancy] New enquiry', from: "#{name} <#{email}>")
  end

  def edit_video_email(video_edit, user_ip)
    @video_edit = video_edit
    @user_ip = user_ip
    mail(to: RECIPIENT, subject: '[Vicancy] Video edits request', from: "Vicancy <info@vicancy.com>")
  end

  def delete_video_email(video, user_ip)
    @video = video
    @user_ip = user_ip
    mail(to: RECIPIENT, subject: '[Vicancy] Delete video request', from: "Vicancy <info@vicancy.com>")
  end

  def video_request_email(video_request)
    @video_request = video_request
    mail(to: RECIPIENT, subject: '[Vicancy] New video request', from: "Vicancy <info@vicancy.com>")
  end

  def notify_simple_order(simple_order, user_ip)
    @simple_order = simple_order
    @user_ip = user_ip
    mail(to: RECIPIENT, subject: '[Vicancy] Lead from the website', from: "Vicancy <info@vicancy.com>")
  end

end



  