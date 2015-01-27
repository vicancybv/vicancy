# == Schema Information
#
# Table name: uploaded_videos
#
#  id               :integer          not null, primary key
#  provider         :string(255)
#  video_id         :integer          indexed
#  aasm_state       :string(255)
#  provider_id      :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  thumb_small      :string(255)
#  thumb_medium     :string(255)
#  thumb_large      :string(255)
#  thumbnail_source :string(255)
#

class UploadedVideo < ActiveRecord::Base
  include AASM

  belongs_to :video
  attr_accessible :aasm_state, :provider, :provider_id, :video_id, :thumb_small, :thumb_medium, :thumb_large, :thumbnail_source
  validates :video_id, :provider, presence: true

  has_attachment :thumbnail

  aasm do
    state :processing, initial: true
    state :uploaded
    state :error

    event :error do
      transitions from: [:processing], to: :error
    end

    event :uploaded do
      transitions from: [:error, :processing], to: :uploaded
    end
  end

  def get_vimeo_thumbnails
    resp = Vimeo::Simple::Video.info(provider_id)
    if resp.success?
      json = resp.parsed_response.first
      self.update_attributes!({
                                  thumb_small: json['thumbnail_small'],
                                  thumb_medium: json['thumbnail_medium'],
                                  thumb_large: json['thumbnail_large']
                              })
    else
      puts "Error! #{resp.response}\n#{resp.body}"
    end
  end

  def get_youtube_thumbnails
    self.update_attributes!({
                                thumb_small: "http://img.youtube.com/vi/#{provider_id}/default.jpg",
                                thumb_medium: "http://img.youtube.com/vi/#{provider_id}/mqdefault.jpg",
                                thumb_large: "http://img.youtube.com/vi/#{provider_id}/hqdefault.jpg"
                            })
  end

  def get_wistia_thumbnails
  end

  def thumbnail_cloudinary_id
    prefix = Settings.production? ? '' : "#{Settings.env}/"
    "#{prefix}uploaded_videos/#{self.id}/thumbnail"
  end

  def thumbnail_from_url(url)
    puts "#{self.provider} thumbnail url: #{url}"
    self.thumbnail_source = url
    self.save!
    self.send(:thumbnail=, nil)
    return if (self.provider == 'vimeo') && (url.include? '/video/default_')
    self.send(:thumbnail_url=, url, :public_id => self.thumbnail_cloudinary_id)
    self.video.regenerate_main_thumbnail
  end

  def build_wistia_thumbnail
    media = Wistia::Media.find(self.provider_id)
    url = media.still(1, { style: '1' }) # don't send size at all
    thumbnail_from_url(url)
  end

  def build_youtube_thumbnail
    url = "http://img.youtube.com/vi/#{provider_id}/hqdefault.jpg"
    thumbnail_from_url(url)
  end

  def get_vimeo_thumbnail
    resp = Vimeo::Simple::Video.info(provider_id)
    if resp.success?
      json = resp.parsed_response.first
      return json['thumbnail_large']
    else
      raise "Error updating thumbnail from vimeo! #{resp.response}\n#{resp.body}"
    end
  end

  def build_vimeo_thumbnail
    url = get_vimeo_thumbnail
    thumbnail_from_url(url)
  end

  def thumbnail_url(options = {})
    if self.thumbnail.present?
      Cloudinary::Utils.cloudinary_url(self.thumbnail.path, options)
    else
      nil
    end
  end

  def build_thumbnail
    if provider == 'vimeo'
      build_vimeo_thumbnail
    elsif provider == 'youtube'
      build_youtube_thumbnail
    elsif provider == 'wistia'
      build_wistia_thumbnail
    end
  end

  def get_thumbnails
    return if thumb_small.present? && thumb_medium.present? && thumb_large.present?
    if provider == 'vimeo'
      get_vimeo_thumbnails
    elsif provider == 'youtube'
      get_youtube_thumbnails
    elsif provider == 'wistia'
      get_wistia_thumbnails
    end
  end
end
