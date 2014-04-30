class Video < ActiveRecord::Base
  include TrelloBoard

  belongs_to  :user
  has_many  :video_edits, dependent: :destroy
  attr_accessible :company, :job_ad_url, :job_title, :language, :summary, :title, :vimeo_id, :youtube_id, :user_id
  attr_accessor :edits
  validates :language, presence: true
  default_scope { order("created_at DESC") }
  has_many :uploaded_videos

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

  def name
    "#{job_title} &ndash; #{company}".html_safe
  end

  def self.create_from_card(card)
    card_params = parse_card_description(card)
    video = Video.find_by :id, id if card_params[:id]
    video ||= Video.new
    video.update_from_card(card)
    video.save
  end

  def update_from_card(card)
    video.title = card_params[:title]
    video.summary = card_params[:summary]
    video.tags = card_params[:tags]
    video.job_title = card_params[:job_title]
    video.job_ad_url = card_params[:url]
    video.language = card_params[:language].try(:downcase) == "en" ? "en" : "nl"
  end

  def provider_title
    name
  end

  def provider_description
    summary
  end

  def tags_array
    []
  end

end
