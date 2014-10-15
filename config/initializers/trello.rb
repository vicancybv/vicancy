require 'trello'
require_relative Rails.root.join('app','models','settings')

# See https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user

Trello.configure do |config|
  config.developer_public_key = Settings.trello_developer_public_key
  config.member_token = Settings.trello_member_token
end