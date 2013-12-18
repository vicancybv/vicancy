class VideoRequest < ActiveRecord::Base
  belongs_to :user
  has_many :attachments
  attr_accessible :comment, :link, :user_id, :user_ip, :attachments_attributes

  accepts_nested_attributes_for :attachments
end
