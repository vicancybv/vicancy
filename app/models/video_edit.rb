class VideoEdit < ActiveRecord::Base
  belongs_to :video
  attr_accessible :edits, :user_ip
end
