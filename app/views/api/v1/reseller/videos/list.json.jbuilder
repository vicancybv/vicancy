json.status 'ok'
json.videos @videos do |video|
  json.id video.id
  json.client do
    json.id video.client.external_id
    json.name video.client.name
  end
  #json.job_title video.job_title
  #json.company video.company
  json.thumbnail video.thumb_small
  json.embed_code embed_code(video)
  #json.video_url video.video_url
  json.published_at video.created_at
end