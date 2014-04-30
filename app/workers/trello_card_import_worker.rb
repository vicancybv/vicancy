class TrelloCardImportWorker
  include Sidekiq::Worker
  include TrelloBoard

  UPLOAD_PROVIDERS = [:youtube, :wistia]

  def perform(card)
    begin
      move_to_list!(card, "processing")    
      video = Video.create_from_card(card) unless already_imported?(card)
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

  def move_to_list!(card, list_name)
    card.list_id = list_by_name(list_name).id
    card.save
  end

  def already_imported?(card)
    id = parse_card_description(card)[:id]
    return false if id.blank?
    !!Video.find(id)
  end

end