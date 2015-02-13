unless defined? Settings
  class Settings

    def self.bitly_access_token
      ENV['BITLY_ACCESS_TOKEN']
    end

    def self.trello_developer_public_key
      ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
    end

    def self.trello_member_token
      ENV['TRELLO_MEMBER_TOKEN']
    end

    def self.trello_board_id
      ENV['TRELLO_BOARD_ID']
    end

    def self.redis_url
      ENV['REDISTOGO_URL']
    end

    def self.wistia_api_password
      ENV['WISTIA_API_PASSWORD']
    end

    def self.wistia_project_id
      ENV['WISTIA_PROJECT_ID']
    end

    def self.vimeo_consumer_key
      ENV['VIMEO_CONSUMER_KEY']
    end

    def self.vimeo_consumer_secret
      ENV['VIMEO_CONSUMER_SECRET']
    end

    def self.vimeo_user_token
      ENV['VIMEO_USER_TOKEN']
    end

    def self.vimeo_user_secret
      ENV['VIMEO_USER_SECRET']
    end

    def self.vimeo_album_id
      ENV['VIMEO_ALBUM_ID']
    end

    def self.google_client_id
      ENV['GOOGLE_CLIENT_ID']
    end

    def self.google_client_secret
      ENV['GOOGLE_CLIENT_SECRET']
    end

    def self.google_dev_key
      ENV['GOOGLE_DEV_KEY']
    end

    def self.google_oauth2_callback_url
      ENV['GOOGLE_OAUTH2_CALLBACK_URL']
    end

    #### Rollbar

    def self.rollbar_access_token
      if Settings.production?
        'f359eb0cda4a46fab1a6c480aecfe54c'
      elsif Settings.staging?
        '0ed3cf5e48dd4ad4a34fe3a439cd72fe'
      else
        # development
        'abede0bfce624d1fa355fde6cfd1b1db'
      end
    end

    #### Cloudinary
    #
    # def self.cloudinary_url
    #
    # end

    #### Environment

    def self.env
      if Settings.production?
        'production'
      elsif Settings.staging?
        'staging'
      elsif Settings.sandbox?
        'sandbox'
      elsif Settings.test?
        'test'
      elsif Settings.development?
        'development'
      else
        Rails.env
      end
    end

    def self.staging?
      ENV['RAILS_ENV_STAGING'].present? ? true : false
    end

    def self.sandbox?
      ENV['RAILS_ENV_SANDBOX'].present? ? true : false
    end

    def self.production?
      Rails.env.production? && !Settings.staging? && !Settings.sandbox?
    end

    def self.development?
      Rails.env.development?
    end

    def self.test?
      Rails.env.test?
    end

    #### Embed settings
    def self.embed_vicancy_server
      if Settings.staging?
        '//stagingvicancy.herokuapp.com'
      elsif Settings.sandbox?
        '//sandboxvicancy.herokuapp.com'
      elsif Settings.production?
        '//vicancy.herokuapp.com'
      elsif Settings.development?
        '//vicancy.dev'
      else
        ''
      end
    end

    #### Widget settings
    def self.widget_vicancy_server
      if Settings.staging?
        '//stagingvicancy.herokuapp.com'
      elsif Settings.sandbox?
        '//sandboxvicancy.herokuapp.com'
      elsif Settings.production?
        '//vicancy.herokuapp.com'
      else
        ''
      end
    end

    # time in minutes
    # if you open the widget within N minutes after first open
    # this sign in doesn't count as new one
    def self.widget_session_length_to_count_as_single_sign_in
      10
    end

    #### Mail settings

    def self.mail_host
      if Settings.staging?
        'stagingvicancy.herokuapp.com'
      elsif Settings.sandbox?
        'sandboxvicancy.herokuapp.com'
      elsif Settings.production?
        'vicancy.com'
      else
        'vicancy.dev'
      end
    end

    def self.default_url_options
      ({ host: Settings::mail_host })
    end

    def self.smtp_settings
      if Settings.production?
        {
            :address => 'smtp.sendgrid.net',
            :port => '587',
            :authentication => :plain,
            :user_name => ENV['SENDGRID_USERNAME'],
            :password => ENV['SENDGRID_PASSWORD'],
            :domain => 'heroku.com',
            :enable_starttls_auto => true
        }
      elsif Settings.staging?
        {
            :user_name => '28221e088c032e698',
            :password => '3e29f84b80492a',
            :address => 'mailtrap.io',
            :domain => 'mailtrap.io',
            :port => '2525',
            :authentication => :cram_md5
        }
        # {
        #     :address => 'smtp.gmail.com',
        #     :port => '587',
        #     :authentication => :plain,
        #     :user_name => 'stagingvicancy@gmail.com',
        #     :password => 'Qurriculum2013',
        #     :domain => 'gmail.com',
        #     :enable_starttls_auto => true
        # }
      else
        Hash.new
      end
    end

  end
end
