require_relative Rails.root.join('app','models','settings')

Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis_url, namespace: 'sidekiq' }

  # for Rails 3.2+, for Rails 4.1 see https://devcenter.heroku.com/articles/concurrency-and-database-connections
  # from https://github.com/mperham/sidekiq/wiki/Advanced-Options
  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=30"
    ActiveRecord::Base.establish_connection
  end
end

#unless Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: Settings.redis_url, namespace: 'sidekiq'  }
  end
#end

# Rollbar already embeds into sidekiq
# Sidekiq.configure_server do |config|
#   config.error_handlers << Proc.new do |ex,ctx_hash|
#     Rollbar.report_exception(ex, ctx_hash)
#   end
# end