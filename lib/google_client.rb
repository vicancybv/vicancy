module GoogleClient
  def new_google_client
  	YouTubeIt::OAuth2Client.new(
      client_access_token: GoogleSession.current_access_token, 
      client_id: Settings.google_client_id,
      client_secret: Settings.google_client_secret,
      dev_key: Settings.google_dev_key
    )
  end
end