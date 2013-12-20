class Video < ActiveRecord::Base
  belongs_to  :user
  has_many  :video_edits
  attr_accessible :company, :job_ad_url, :job_title, :language, :summary, :title, :vimeo_id, :youtube_id, :user_id
  attr_accessor :edits
  validates :language, presence: true
  default_scope { order("created_at DESC") }

  def video_url
    return vimeo_url unless vimeo_id.blank?
    return youtube_url unless youtube_id.blank?
  end

  def embed_url
    return vimeo_embed_url unless vimeo_id.blank?
    return youtube_embed_url unless youtube_id.blank?
  end

  def vimeo_url(fallback=false)
    return youtube_url if fallback && vimeo_id.blank?
    "http://vimeo.com/#{vimeo_id}"
  end

  def vimeo_embed_url(fallback=false)
    return youtube_embed_url if fallback && vimeo_id.blank?
    "http://player.vimeo.com/video/#{vimeo_id}"
  end

  def youtube_url(fallback=false)
    return vimeo_url if fallback && youtube_id.blank?
    "http://www.youtube.com/watch?v=#{youtube_id}"
  end

  def youtube_embed_url(fallback=false)
    return vimeo_embed_url if fallback && youtube_id.blank?
    "http://www.youtube.com/embed/#{youtube_id}"
  end

end
