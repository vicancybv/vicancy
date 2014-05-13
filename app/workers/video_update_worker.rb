class VideoUpdateWorker
  include Sidekiq::Worker
  include TrelloBoard
  include GoogleClient

  def perform(card_id)
    begin
      card = Trello::Card.find(card_id)
      raise TrelloCardNotFound unless card
      move_to_list!(card, "processing")    
      video = already_imported_video(card) 
      raise VideoNotFound unless video
      video.update_from_card(card)
      Rails.logger.info video.inspect
      video.save
      video.uploaded_videos.each do |uploaded_video|
        send("#{uploaded_video.provider}_update", uploaded_video)
      end
    rescue Exception => e
      update_card_description(card, error: e)
      move_to_list!(card, "error")
    end
  end

  def youtube_update(uploaded_video)
    client = new_google_client
    video = uploaded_video.video
    response = client.video_update(uploaded_video.provider_id, 
      title: video.provider_title,
      description: video.provider_description, 
      keywords: video.tags_array,
      list: "denied")
    Rails.logger.info response
  end

  def wistia_update(uploaded_video)
    media = Wistia::Media.find(uploaded_video.provider_id)
    raise WistiaVideoNotFound unless media
    media.name = uploaded_video.video.provider_title
    media.description = uploaded_video.video.provider_description
    response = media.save
    Rails.logger.info response
  end


end