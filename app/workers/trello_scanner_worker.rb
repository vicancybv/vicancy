class TrelloScannerWorker
  include Sidekiq::Worker
  include TrelloBoard

  sidekiq_options :retry => false

  def perform
    ready_to_upload.each do |card|
      TrelloCardImportWorker.perform_async(card.id)
    end
    ready_to_update.each do |card|
      VideoUpdateWorker.perform_async(card.id)
    end
  end

  def ready_to_upload
    # We only want cards with an MP4 attachment
    list_by_name("Ready for upload").cards.select do |card| 
      !extract_video_attachment_url(card).blank?
    end
  end

  def ready_to_update
    list_by_name("Ready to update").cards
  end

end