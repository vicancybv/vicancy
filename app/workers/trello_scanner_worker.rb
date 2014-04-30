class TrelloScannerWorker
  include Sidekiq::Worker
  include TrelloBoard

  def perform
    cards.each do |card|
      TrelloCardImportWorker.perform_async(card)
    end
  end

  def cards
    # We only want cards with an MP4 attachment
    list_by_name("Ready for upload").cards.select do |card| 
      !extract_video_attachment_url(card).blank?
    end
  end

end