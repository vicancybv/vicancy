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

end