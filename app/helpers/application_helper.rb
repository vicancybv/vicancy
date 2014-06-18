module ApplicationHelper

  def google_oauth2_url
    "https://accounts.google.com/o/oauth2/auth?client_id=#{ENV['GOOGLE_CLIENT_ID']}&redirect_uri=#{ENV['GOOGLE_OAUTH2_CALLBACK_URL']}&scope=https%3A%2F%2Fgdata.youtube.com&response_type=code&approval_prompt=force&access_type=offline&pageId=none"
  end

end
