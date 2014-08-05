# == Schema Information
#
# Table name: video_edits
#
#  id         :integer          not null, primary key
#  edits      :text
#  video_id   :integer          indexed
#  user_ip    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VideoEdit < ActiveRecord::Base
  belongs_to :video
  attr_accessible :edits, :user_ip
end
