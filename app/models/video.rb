class Video < ActiveRecord::Base
  attr_accessible :company, :job_ad_url, :job_title, :language, :summary, :title, :vimeo_id, :youtube_id
end
