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
        Video.create_from_card(card) 
        update_card_description(card, id: video.id)
        card.save
      end
      video_url = extract_video_attachment_url(card)
      UPLOAD_PROVIDERS.each do |provider|
        uploaded_video = video.uploaded_videos.create(provider: provider)
        VideoUploadWorker.perform_async(uploaded_video.id, video_url)
      end
    rescue Exception => e
      update_card_description(card, error: e)
      move_to_list!(card, "error")
    end
  end

  # Will not move lists, but still save, if list doesn't exist
  def move_to_list!(card, list_name)
    list_id = list_by_name(list_name).try(:id)
    card.list_id = list_id if list_id
    card.save
  end

  def already_imported_video(card)
    id = parse_card_description(card)[:id]
    return nil if id.blank?
    Video.find(id) rescue nil
  end

end