# == Schema Information
#
# Table name: video_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  user_ip    :string(255)
#  link       :string(255)
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VideoRequest < ActiveRecord::Base
  belongs_to :user
  has_many :attachments
  attr_accessible :comment, :link, :user_id, :user_ip, :attachments_attributes

  accepts_nested_attributes_for :attachments
end
