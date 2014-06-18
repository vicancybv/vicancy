require 'trello'
# See https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user
Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end