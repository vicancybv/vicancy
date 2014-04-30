class UploadedVideo < ActiveRecord::Base
  include AASM

  belongs_to :video
  attr_accessible :aasm_state, :provider, :provider_id
  validates :video_id, :provider, presence: true

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

end
