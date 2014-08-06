source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.16'

gem 'activeadmin'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
                              :github => 'anjlab/bootstrap-rails'
gem 'font-awesome-rails'
gem 'paperclip'
gem 'aws-sdk', '~> 1.5.7'
gem 'jbuilder'

gem 'aasm'
gem 'sidekiq'
gem 'ruby-trello'
gem 'oauth2'
gem 'youtube_it', :github => 'tobymarsden/youtube_it'
gem 'wistia-uploader'
gem 'wistia-api'
gem 'vimeo'
gem 'unicorn'
gem 'sidekiq-scheduler', '~> 1'
gem 'strong_parameters'

# API documentation
gem 'rspec_api_documentation', '~> 3.1.0'
gem 'apitome'

group :development do
  gem "binding_of_caller"
  gem 'better_errors'
  gem 'annotate', '~> 2.6.5'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'figaro'
  gem 'factory_girl_rails'
end

group :production do
	gem 'pg'
  # For Heroku
	gem 'rails_12factor'
	gem 'dalli'
	gem 'memcachier'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass',         '~> 3.2.13'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

#gem 'jquery-rails'
gem 'jquery-rails', '~> 2.3.0'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'