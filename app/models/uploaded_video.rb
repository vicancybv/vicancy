# == Schema Information
#
# Table name: uploaded_videos
#
#  id          :integer          not null, primary key
#  provider    :string(255)
#  video_id    :integer          indexed
#  aasm_state  :string(255)
#  provider_id :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UploadedVideo < ActiveRecord::Base
  include AASM

  belongs_to :video
  attr_accessible :aasm_state, :provider, :provider_id, :video_id
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

end
