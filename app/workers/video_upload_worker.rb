class VideoUploadWorker
  include Sidekiq::Worker
  include TrelloBoard
  include GoogleClient

  sidekiq_options :retry => false

  def perform(uploaded_video_id, video_url)
    uploaded_video = UploadedVideo.find(uploaded_video_id)
    begin
      send("#{uploaded_video.provider}_upload", uploaded_video, video_url)
      UploadedVideoThumbnailWorker.perform_async(uploaded_video_id)
    rescue Exception => e
      msg = "Error during #{uploaded_video.provider} upload (#{e.class.to_s}). #{e.message}"
      card = processing_card_for_video_id(uploaded_video.video.id)
      if card
        update_card_description(card, error: msg)
        move_to_list!(card, "error")
      end
      raise
    end
  end

  def youtube_upload(uploaded_video, url)
    video = uploaded_video.video
    # TODO: raise if no current access_token
    client = new_google_client
    response = client.video_upload(open(url),
                                   title: video.provider_title,
                                   description: video.provider_description(:youtube),
                                   keywords: video.tags_array,
                                   list: "denied")
    uploaded_video.update_attribute(:provider_id, response.unique_id)
  end

  def wistia_upload(uploaded_video, url)
    thread = WistiaUploader.upload_media(Settings.wistia_api_password, Settings.wistia_project_id, open(url))
    # Wait for thread to complete
    thread.join
    response = JSON.parse(thread[:body])
    if thread[:upload_status] == :success && wistia_id = response["id"]
      uploaded_video.update_attribute(:provider_id, wistia_id)
      media = Wistia::Media.find(wistia_id)
      media.name = uploaded_video.video.provider_title
      media.description = uploaded_video.video.provider_description(:wistia)
      media.save
    else
      uploaded_video.error!
      raise "Response: #{thread[:body]}"
    end
  end

  def vimeo_upload(uploaded_video, url)
    video = uploaded_video.video
    upload_api = Vimeo::Advanced::Upload.new(Settings.vimeo_consumer_key, Settings.vimeo_consumer_secret, :token => Settings.vimeo_user_token, :secret => Settings.vimeo_user_secret)
    video_api = Vimeo::Advanced::Video.new(Settings.vimeo_consumer_key, Settings.vimeo_consumer_secret, :token => Settings.vimeo_user_token, :secret => Settings.vimeo_user_secret)
    response = upload_api.upload(open(url))
    vimeo_id = response["ticket"]["video_id"] rescue nil
    if vimeo_id
      uploaded_video.update_attribute(:provider_id, vimeo_id)
      video_api.add_tags(vimeo_id, video.tags)
      video_api.set_title(vimeo_id, video.provider_title)
      video_api.set_description(vimeo_id, video.provider_description(:vimeo))
      if Settings.vimeo_album_id
        album_api = Vimeo::Advanced::Album.new(Settings.vimeo_consumer_key, Settings.vimeo_consumer_secret, :token => Settings.vimeo_user_token, :secret => Settings.vimeo_user_secret)
        album_api.add_video(Settings.vimeo_album_id, vimeo_id)
      end
    else
      uploaded_video.error!
      raise "Response: #{response.to_json}"
    end
  end

end