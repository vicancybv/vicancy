class VideoUploadWorker
  include Sidekiq::Worker
  include TrelloBoard
  include GoogleClient

  def perform(uploaded_video_id, video_url)
    uploaded_video = UploadedVideo.find(uploaded_video_id)
    begin
      send("#{uploaded_video.provider}_upload", uploaded_video, video_url)
    rescue Exception => e
      card = processing_card_for_video_id(uploaded_video.video.id)
      if card
        update_card_description(card, error: e)
        move_to_list!(card, "error")
      end
    end
  end

  def youtube_upload(uploaded_video, url)
    video = uploaded_video.video
    # TODO: raise if no current access_token
    client = new_google_client
    response = client.video_upload(open(url), 
      title: video.provider_title,
      description: video.provider_description, 
      keywords: video.tags_array,
      list: "denied")
    uploaded_video.update_attribute(:provider_id, response.unique_id)
  end

  def wistia_upload(uploaded_video, url)
    thread = WistiaUploader.upload_media(ENV['WISTIA_API_PASSWORD'], ENV['WISTIA_PROJECT_ID'], url)
    # Wait for thread to complete
    thread.join
    response = JSON.parse(thread[:body])
    if thread[:upload_status] == :success && wistia_id = response["id"]
      uploaded_video.update_attribute(:provider_id, wistia_id)
      media = Wistia::Media.find(wistia_id)
      media.name = uploaded_video.video.provider_title
      media.description = uploaded_video.video.provider_description
      media.save
    else
      uploaded_video.error!
    end
  end

  def vimeo_upload(uploaded_video, url)
    video = uploaded_video.video
    url = "http://trello-attachments.s3.amazonaws.com/532ffa69f653d97c21879d1d/53622e5ba683db2e29abcbe3/9644c0158297f99e997af539c8dedd7b/Promo_405p.mp4"
    upload_api = Vimeo::Advanced::Upload.new(ENV['VIMEO_CONSUMER_KEY'], ENV['VIMEO_CONSUMER_SECRET'], :token => ENV['VIMEO_USER_TOKEN'], :secret => ENV['VIMEO_USER_SECRET'])
    video_api = Vimeo::Advanced::Video.new(ENV['VIMEO_CONSUMER_KEY'], ENV['VIMEO_CONSUMER_SECRET'], :token => ENV['VIMEO_USER_TOKEN'], :secret => ENV['VIMEO_USER_SECRET'])
    vimeo_id = upload_api.upload(open(url))
    if vimeo_id
      uploaded_video.update_attribute(:provider_id, vimeo_id)
      video_api.add_tags(vimeo_id, video.tags_array)
      video_api.set_title(vimeo_id, video.provider_title)
      video_api.set_description(vimeo_id, video.provider_description)
    else
      uploaded_video.error!
    end
  end

end