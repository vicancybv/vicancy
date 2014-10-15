require_relative Rails.root.join('app','models','settings')

Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis_url, namespace: 'sidekiq' }
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