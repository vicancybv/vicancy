class TrelloCardImportWorker
  include Sidekiq::Worker
  include TrelloBoard

  sidekiq_options :retry => false

  UPLOAD_PROVIDERS = [:youtube, :wistia, :vimeo]

  def perform(card_id)
    begin
      card = Trello::Card.find(card_id)
      raise TrelloCardNotFound unless card
      move_to_list!(card, "processing")    
      video = already_imported_video(card) 
      unless video
        video = Video.create_from_card(card) 
        update_card_description(card, id: video.id)
        card.save
      end
      video.update_attribute(:aasm_state, "processing")
      video_url = extract_video_attachment_url(card)
      UPLOAD_PROVIDERS.each do |provider|
        card_provider = parse_card_description(card)[provider].try(:downcase)
        unless card_provider == "false" || card_provider == "no"
          uploaded_video = video.uploaded_videos.find_by_provider(provider) || video.uploaded_videos.create(provider: provider)
          uploaded_video.update_attribute(:aasm_state, "processing")
          VideoUploadWorker.perform_async(uploaded_video.id, video_url)
        end
      end
    rescue Exception => e
      msg = "Error during card processing (#{e.class.to_s}). #{e.message}"
      update_card_description(card, error: msg)
      move_to_list!(card, "error")
      raise
    end
  end

end