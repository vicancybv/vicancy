class Settings
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
      'http://vicancy.com'
    else
      ''
    end
  end

end