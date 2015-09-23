class ProviderScannerWorker
  include Sidekiq::Worker
  include TrelloBoard

  sidekiq_options :retry => false

  def perform
    UploadedVideo.where(aasm_state: 'processing').each do |uploaded_video|
      process_uploaded_video(uploaded_video)
    end
    Video.where(aasm_state: 'processing').each do |video|
      process_video(video)
    end
  end

  def process_uploaded_video(uploaded_video)
    state = nil
    begin
      state = send("#{uploaded_video.provider}_video_status", uploaded_video.provider_id)
      if state == :error
        msg = "Undefined error during #{uploaded_video.provider} video (uploaded video id: #{uploaded_video.id}) status check."
        add_coment_to_video_card(uploaded_video.video.id, msg)
      end
    rescue => e
      Rollbar.report_exception(e, rollbar_request_data)
      state = :error
      uploaded_video.update_attribute(:aasm_state, state.to_s)
      msg = "Error during #{uploaded_video.provider} video (uploaded video id: #{uploaded_video.id}) status check (#{e.class.to_s}). #{e.message}"
      add_coment_to_video_card(uploaded_video.video.id, msg)
    end
    uploaded_video.update_attribute(:aasm_state, state.to_s) if uploaded_video.aasm_state != state.to_s
  end

  def process_video(video)
    video.error! if video.uploaded_videos.any? { |uv| uv.aasm_state == 'error' }
    video.uploaded! if video.uploaded_videos.all? { |uv| uv.aasm_state == 'uploaded' }
    case video.aasm_state
      when "error" then
        move_card_for_video_to_list(video.id, "Error")
      when "uploaded" then
        move_card_for_video_to_list(video.id, "Processed")
    end
  end

  # Return :error, :processing or :uploaded
  def youtube_video_status(id)
    client = YouTubeIt::OAuth2Client.new(
        client_access_token: GoogleSession.current_access_token,
        client_id: Settings.google_client_id,
        client_secret: Settings.google_client_secret,
        dev_key: Settings.google_dev_key
    )
    video = client.video_by(id) rescue nil
    return :error if video.nil?
    #processing, restricted, deleted, rejected and failed
    return :uploaded if video.state.nil?
    return :processing if video.state[:name] == "processing"
    return :error
  end

  # Return :error, :processing or :uploaded
  def wistia_video_status(id)
    video = Wistia::Media.find(id) rescue nil
    return :error if video.nil?
    # queued, processing, ready, and failed
    case video.status
      when "queued", "processing" then
        :processing
      when "ready" then
        :uploaded
      else
        :error
    end
  end

  def vimeo_video_status(id)
    video_api = Vimeo::Advanced::Video.new(Settings.vimeo_consumer_key, Settings.vimeo_consumer_secret, :token => Settings.vimeo_user_token, :secret => Settings.vimeo_user_secret)
    info = video_api.get_info(id)
    case info["stat"]
      when "ok" then
        :uploaded
      else
        :error
    end
  end

end