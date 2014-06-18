module GoogleClient
  def new_google_client
  	YouTubeIt::OAuth2Client.new(
      client_access_token: GoogleSession.current_access_token, 
      client_id: ENV['GOOGLE_CLIENT_ID'], 
      client_secret: ENV['GOOGLE_CLIENT_SECRET'], 
      dev_key: ENV['GOOGLE_DEV_KEY']
    )
  end
end