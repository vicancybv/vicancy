require_relative Rails.root.join('app','models','settings')

Bitly.use_api_version_3

Bitly.configure do |config|
  config.api_version = 3
  config.access_token = Settings.bitly_access_token
end
