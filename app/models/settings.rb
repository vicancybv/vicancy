class Settings

  # time in minutes
  # if you open the widget within N minutes after first open
  # this sign in doesn't count as new one
  def self.widget_session_length_to_count_as_single_sign_in
    10
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

  def self.widget_vicancy_server
    if Settings.staging?
      'http://stagingvicancy.herokuapp.com'
    elsif Settings.sandbox?
      'http://sandboxvicancy.herokuapp.com'
    elsif Settings.production?
      'http://www.vicancy.com'
    else
      ''
    end
  end

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

end