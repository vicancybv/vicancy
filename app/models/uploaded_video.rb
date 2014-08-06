# == Schema Information
#
# Table name: uploaded_videos
#
#  id           :integer          not null, primary key
#  provider     :string(255)
#  video_id     :integer          indexed
#  aasm_state   :string(255)
#  provider_id  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  thumb_small  :string(255)
#  thumb_medium :string(255)
#  thumb_large  :string(255)
#

class UploadedVideo < ActiveRecord::Base
  include AASM

  belongs_to :video
  attr_accessible :aasm_state, :provider, :provider_id, :video_id, :thumb_small, :thumb_medium, :thumb_large
  validates :video_id, :provider, presence: true

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
