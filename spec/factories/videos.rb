# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  youtube_id :string(255)
#  vimeo_id   :string(255)
#  job_ad_url :string(255)
#  job_title  :string(255)
#  company    :string(255)
#  language   :string(255)
#  title      :string(255)
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  place      :string(255)
#  tags       :string(255)
#  aasm_state :string(255)
#  client_id  :integer          indexed
#

#  id         :integer          not null, primary key
#  youtube_id :string(255)
#  vimeo_id   :string(255)
#  job_ad_url :string(255)
#  job_title  :string(255)
#  company    :string(255)
#  language   :string(255)
#  title      :string(255)
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  place      :string(255)
#  tags       :string(255)
#  aasm_state :string(255)

FactoryGirl.define do

  factory :video do
    youtube_id 'youtube'
    vimeo_id 'vimeo'
    job_ad_url 'http://jobad'
    job_title 'Super Job'
    company 'Super Company'
    language 'es'
    title 'Video Title'
    summary 'Quick Summary'
  end

end
