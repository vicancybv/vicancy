# == Schema Information
#
# Table name: video_requests
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  user_ip         :string(255)
#  link            :string(255)
#  comment         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :integer          indexed
#  external_job_id :string(255)
#

class VideoRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
  has_many :attachments
  attr_accessible :comment, :link, :user_id, :client_id, :user_ip, :attachments_attributes
  attr_accessible :external_job_id

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :client, :prefix => true, :allow_nil => true

  accepts_nested_attributes_for :attachments
end
