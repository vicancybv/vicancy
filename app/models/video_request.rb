class VideoRequest < ActiveRecord::Base
  belongs_to :user
  attr_accessible :comment, :link, :user_id, :user_ip
end
