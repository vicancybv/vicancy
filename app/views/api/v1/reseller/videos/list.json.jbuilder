json.status 'ok'
json.videos @videos do |video|
  json.id video.id
  json.client do
    json.id video.client.external_id
    json.name video.client.name
  end
  json.job_url video.job_url
  json.thumbnail video.thumb_small
  json.embed_code embed_code(video)
  json.published_at video.created_at
end