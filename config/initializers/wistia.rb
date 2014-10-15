require 'wistia'
require_relative Rails.root.join('app','models','settings')

Wistia.password = Settings.wistia_api_password