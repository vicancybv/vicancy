module VideosHelper

  def video_title(video)
    return video.title unless video.title.blank?
    "#{video.company}#{" &ndash; " unless video.company.blank? || video.job_title.blank?}#{video.job_title}".html_safe
  end

end
