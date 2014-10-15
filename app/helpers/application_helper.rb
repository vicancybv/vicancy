module ApplicationHelper

  def google_oauth2_url
    "https://accounts.google.com/o/oauth2/auth?client_id=#{Settings.google_client_id}&redirect_uri=#{Settings.google_oauth2_callback_url}&scope=https%3A%2F%2Fgdata.youtube.com&response_type=code&approval_prompt=force&access_type=offline&pageId=none"
  end

end
