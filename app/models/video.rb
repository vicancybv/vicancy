# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  youtube_id :string(255)
#  vimeo_id   :string(255)
#  job_ad_url :string(255)
#  job_title  :string(255)
#  company    :string(255)
#  language   :string(255)
#  title      :string(255)
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  place      :string(255)
#  tags       :string(255)
#  aasm_state :string(255)
#  client_id  :integer          indexed
#

class Video < ActiveRecord::Base
  include AASM
  extend TrelloBoard

  belongs_to  :user
  belongs_to  :client

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :client, :prefix => true, :allow_nil => true
  delegate :reseller, :to => :client, :allow_nil => true

  has_many  :video_edits, dependent: :destroy
  attr_accessible :company, :job_ad_url, :job_title, :language, :summary, :title, :user_id, :client_id
  attr_accessible :youtube_id, :vimeo_id

  attr_accessor :edits
  validates :language, presence: true
  default_scope { order("created_at DESC") }
  has_many :uploaded_videos

  aasm do
    state :processing, initial: true
    state :uploaded
    state :error

    event :error do
      transitions from: [:processing], to: :error
    end

    event :uploaded do
      transitions from: [:processing], to: :uploaded
    end
  end

  def vimeo_id
    provider_id(:vimeo)
  end

  def youtube_id
    provider_id(:youtube)
  end

  def wistia_id
    provider_id(:wistia)
  end

  def provider_id(provider)
    self.uploaded_videos.select{|u| u.provider == provider.to_s}.first.try(:provider_id)
  end

  def video_url
    return vimeo_url unless vimeo_id.blank?
    return youtube_url unless youtube_id.blank?
  end

  def embed_url
    return wistia_embed_url unless wistia_id.blank?
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

  def wistia_embed_url(fallback=false)
    "http://fast.wistia.net/embed/iframe/#{wistia_id}?version=v1&videoHeight=360&videoWidth=640"
  end

  def name
    "#{job_title} &ndash; #{company}".html_safe
  end

  def self.create_from_card(card)
    card_params = Video.parse_card_description(card)
    video = Video.find_by :id, id if card_params[:id]
    video ||= Video.new
    video.update_from_card_params(card_params)
    video.save
    video
  end

  def update_from_card(card)
    card_params = Video.parse_card_description(card)
    update_from_card_params(card_params)
  end

  def update_from_card_params(card_params)
    self.title = card_params[:title].to_s.strip
    self.summary = card_params[:summary].to_s.strip
    self.tags = card_params[:tags].to_s.strip
    self.job_title = card_params[:job_title].to_s.strip
    self.company = card_params[:company].to_s.strip
    self.place = card_params[:place].to_s.strip
    self.job_ad_url = card_params[:url].to_s.strip
    self.language = card_params[:language].try(:downcase).to_s.strip == "en" ? "en" : "nl"
    self.user = User.find_by_slug(card_params[:user].to_s.strip)
  end

  def provider_title
    return title unless title.blank?
    "#{job_title} - #{company}"
  end

  def provider_description(provider = :youtube)
    return summary unless summary.blank?
    i18n_key = place.blank? ? 'description_without_place' : 'description_with_place'
    I18n.t(:"providers.#{provider.to_s}.#{i18n_key}", locale: language, company: company, job_title: job_title, job_ad_url: job_ad_url, place: place)
  end

  def tags_array
    tags.split(",").map{|t| t.strip}
  end

end
