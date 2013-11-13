class Video < ActiveRecord::Base
  belongs_to  :user
  attr_accessible :company, :job_ad_url, :job_title, :language, :summary, :title, :vimeo_id, :youtube_id, :user_id
  validates :language, presence: true
end
