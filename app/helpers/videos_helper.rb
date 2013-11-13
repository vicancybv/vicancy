module VideosHelper

  def video_title(video)
    return video.title unless video.title.blank?
    "#{video.company}#{" &ndash; " unless video.company.blank? || video.job_title.blank?}#{video.job_title}".html_safe
  end

  def facebook_share_link(video)
    "https://www.facebook.com/sharer/sharer.php?u=#{video.video_url}&title=#{video_title(video)}"
  end

  def twitter_share_link(video)
    "https://twitter.com/intent/tweet?url=#{video.video_url}"
  end

  def linkedin_share_link(video)
    "http://www.linkedin.com/shareArticle?mini=true&url=#{video.video_url}&title=#{video_title(video)}&summary={articleSummary}"
  end

end
