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
      video.save
      video.uploaded_videos.each do |uploaded_video|
        send("#{uploaded_video.provider}_update", uploaded_video)
      end
      move_to_list!(card, "processed")
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
      description: video.provider_description(:youtube), 
      keywords: video.tags_array,
      list: "denied")
  end

  def wistia_update(uploaded_video)
    media = Wistia::Media.find(uploaded_video.provider_id)
    raise WistiaVideoNotFound unless media
    media.name = uploaded_video.video.provider_title
    media.description = uploaded_video.video.provider_description(:wistia)
    response = media.save
  end

  def vimeo_update(uploaded_video)
    video = uploaded_video.video
    vimeo_id = uploaded_video.provider_id
    video_api = Vimeo::Advanced::Video.new(ENV['VIMEO_CONSUMER_KEY'], ENV['VIMEO_CONSUMER_SECRET'], :token => ENV['VIMEO_USER_TOKEN'], :secret => ENV['VIMEO_USER_SECRET'])
    video_api.add_tags(vimeo_id, video.tags)
    video_api.set_title(vimeo_id, video.provider_title)
    video_api.set_description(vimeo_id, video.provider_description(:vimeo))
  end


end