class VideoUploadWorker
  include Sidekiq::Worker
  include TrelloBoard

  def perform(uploaded_video_id, video_url)
    uploaded_video = UploadedVideo.find(uploaded_video_id)
    send("#{uploaded_video.provider}_upload", uploaded_video, video_url)
  end

  def youtube_upload(uploaded_video, url)
    video = uploaded_video.video
    # TODO: raise if no current access_token
    client = YouTubeIt::OAuth2Client.new(
      client_access_token: GoogleSession.current_access_token, 
      client_id: ENV['GOOGLE_CLIENT_ID'], 
      client_secret: ENV['GOOGLE_CLIENT_SECRET'], 
      dev_key: ENV['GOOGLE_DEV_KEY']
    )
    client.video_upload(open(url), 
      title: video.provider_title,
      description: video.provider_description, 
      keywords: video.tags_array,
      list: "denied")
  end

  def wistia_upload(uploaded_video, url)
    thread = WistiaUploader.upload_media(ENV['WISTIA_API_PASSWORD'], ENV['WISTIA_PROJECT_ID'], url)
    response = JSON.parse(thread[:body])
    if thread[:upload_status] == :success
      uploaded.video.update_attribute(:provider_id, response["id"])
    else
      uploaded_video.error!
    end
  end

end