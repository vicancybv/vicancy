class UploadedVideoThumbnailWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 10

  sidekiq_retry_in do |count|
    2 * (count + 1) # (i.e. 2, 4, 6, 8, 10, 12, 14, 16, 18, 20) - will fail after 110 seconds
  end

  sidekiq_retries_exhausted do |msg|
    message = "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    Rollbar.report_message(message, 'error', msg)
  end

  # batch_mode mode is used for rake task to quickly repair missing thumbnails
  def perform(uploaded_video_id, batch_mode = false)
    uploaded_video = UploadedVideo.find(uploaded_video_id)
    uploaded_video.build_thumbnail if uploaded_video.thumbnail.blank?
    raise "Failed to load #{uploaded_video.provider} thumbnail for uploaded_video.id=#{uploaded_video.id}" if uploaded_video.thumbnail.blank?
  rescue => e
    if batch_mode
      # silently swallow exception if run from rake task
    else
      # report error as info and raise exception without additional reporting to Rollbar
      Rollbar.report_exception(e, nil, nil, 'info')
      Rollbar.silenced { raise }
    end
  end

end