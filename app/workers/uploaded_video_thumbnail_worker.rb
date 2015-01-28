class UploadedVideoThumbnailWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 20

  sidekiq_retry_in do |count|
    2 * (count + 1) # (i.e. 2, 4, 6, 8)
  end

  sidekiq_retries_exhausted do |msg|
    Rollbar.log_warning("Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}")
  end

  # do_not_fail mode is used for rake task to quickly repair missing thumbnails
  def perform(uploaded_video_id, do_not_fail = false)
    uploaded_video = UploadedVideo.find(uploaded_video_id)
    uploaded_video.build_thumbnail if uploaded_video.thumbnail.blank?
    raise "Failed to load #{uploaded_video.provider} thumbnail for uploaded_video.id=#{uploaded_video.id}" if uploaded_video.thumbnail.blank?
  rescue
    raise unless do_not_fail
  end

end