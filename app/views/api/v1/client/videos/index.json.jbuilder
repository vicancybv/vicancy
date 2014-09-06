json.status 'ok'
json.requests @requests
json.videos @videos do |video|
  json.id video.id
  json.job_title video.job_title
  json.company video.company
  json.youtube_id video.youtube_id
  json.vimeo_id video.vimeo_id
  json.wistia_id video.wistia_id
  json.thumb_small video.thumb_small
  json.twitter_share twitter_share_link(video)
  json.facebook_share facebook_share_link(video)
  json.linkedin_share linkedin_share_link(video)
end