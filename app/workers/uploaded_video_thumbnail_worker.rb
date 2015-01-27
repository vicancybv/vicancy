class UploadedVideoThumbnailWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 20

  sidekiq_retry_in do |count|
    5 * (count + 1) # (i.e. 5, 10, 15, 20)
  end

  sidekiq_retries_exhausted do |msg|
    Rollbar.log_warning("Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}")
  end

  def perform(uploaded_video_id)
    uploaded_video = UploadedVideo.find(uploaded_video_id)
    uploaded_video.build_thumbnail if uploaded_video.thumbnail.blank?
  end

end