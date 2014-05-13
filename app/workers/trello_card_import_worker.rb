class TrelloCardImportWorker
  include Sidekiq::Worker
  include TrelloBoard

  UPLOAD_PROVIDERS = [:youtube, :wistia]

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
      video_url = extract_video_attachment_url(card)
      UPLOAD_PROVIDERS.each do |provider|
        card_provider = parse_card_description(card)[provider].try(:downcase)
        unless card_provider == "false" || card_provider == "no"
          uploaded_video = video.uploaded_videos.find_by_provider(provider) || video.uploaded_videos.create(provider: provider)
          VideoUploadWorker.perform_async(uploaded_video.id, video_url)
        end
      end
    rescue Exception => e
      update_card_description(card, error: e)
      move_to_list!(card, "error")
    end
  end

end