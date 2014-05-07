class ProviderScannerWorker
  include Sidekiq::Worker
  include TrelloBoard

  def perform
    UploadedVideo.where(aasm_state: 'processing').each do |uploaded_video|
      state = send("#{uploaded_video.provider}_video_status", uploaded_video.provider_id)
      uploaded_video.update_attribute(:aasm_state, state.to_s) if uploaded_video.aasm_state != state.to_s 
    end
    Video.where(aasm_state: 'processing').each do |video|
      video.error! if video.uploaded_videos.select{|uv| uv.aasm_state == 'error'}
      video.uploaded! if video.uploaded_videos.all?{|uv| uv.aasm_state == 'uploaded'}
      case video.aasm_state
        when "error" then move_card_for_video_to_list(video.id, "Error")
        when "uploaded" then move_card_for_video_to_list(video.id, "Processed")
      end
    end
  end

  # Return :error, :processing or :uploaded
  def youtube_video_status(id)
    client = YouTubeIt::OAuth2Client.new(
      client_access_token: GoogleSession.current_access_token, 
      client_id: ENV['GOOGLE_CLIENT_ID'], 
      client_secret: ENV['GOOGLE_CLIENT_SECRET'], 
      dev_key: ENV['GOOGLE_DEV_KEY']
    )
    video = client.video_by("FQK1URcxmb4")
    return :error if video.nil?
    #processing, restricted, deleted, rejected and failed
    case video.state
      when :processing then :processing
      when nil then :uploaded
      else :error
    end
  end

  # Return :error, :processing or :uploaded
  def wistia_video_status(id)
    video = Wistia::Media.find(id) rescue nil
    return :error if video.nil?
    # queued, processing, ready, and failed
    case video.status
      when "queued", "processing" then :processing
      when "ready" then :uploaded
      else :error
    end
  end

  def processing_cards
    list_by_name("Processing").cards
  end

  def processing_card_for_video_id(id)
    processing_cards.select{|card| parse_card_description(card)[:id] == id.to_s}.first
  end

  def move_card_for_video_to_list(video_id, list_name)
    card = processing_card_for_video_id(video_id)
    move_to_list!(card, list_name) unless card.nil?
  end

end