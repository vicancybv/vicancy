module VideosHelper

  def video_title(video)
    return video.title unless video.title.blank?
    "#{video.company}#{" - " unless video.company.blank? || video.job_title.blank?}#{video.job_title}".html_safe
  end

  def facebook_share_link(video)
    #"https://www.facebook.com/sharer/sharer.php?s=100&p[url]=#{video.video_url}&p[title]=#{video_title(video)}&p[summary]=#{I18n.t(:'sharing.facebook', locale: video.language, company: video.company, job_title: video.job_title, job_ad_url: video.job_ad_url, video_url: video.video_url)}"
    "https://www.facebook.com/sharer/sharer.php?u=#{video.video_url}"
  end

  def twitter_share_link(video)
    "https://twitter.com/intent/tweet?text=#{I18n.t(:'sharing.twitter', locale: video.language, company: video.company, job_title: video.job_title, job_ad_url: video.job_ad_url, video_url: video.video_url)}"
  end

  def linkedin_share_link(video)
    "http://www.linkedin.com/shareArticle?mini=true&url=#{video.youtube_url}&title=#{video_title(video)}&summary=#{I18n.t(:'sharing.linkedin', locale: video.language, company: video.company, job_title: video.job_title, job_ad_url: video.job_ad_url, video_url: video.video_url)}"
  end

end
