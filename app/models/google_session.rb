# == Schema Information
#
# Table name: google_sessions
#
#  id            :integer          not null, primary key
#  access_token  :string(255)
#  expires_at    :datetime
#  refresh_token :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class GoogleSession < ActiveRecord::Base
  attr_accessible :access_token, :expires_at, :refresh_token

  validates :access_token, :expires_at, :refresh_token, presence: true

  def self.find
    self.first
  end

  def self.current_access_token
    session = self.find
    return nil unless session
    return session.access_token if session.expires_at > Time.now.utc
    session.refresh_access_token!
  end

  def get_access_token!(code)
    credentials = send_oauth2_request({
      'code' => code,
      'grant_type' => 'authorization_code',
      'redirect_uri' => Settings.google_oauth2_callback_url
    })

    set_access_token_and_expiry(credentials)
    self.refresh_token = credentials['refresh_token']
    save
  end

  def set_access_token_and_expiry(credentials)
    self.access_token = credentials['access_token']
    self.expires_at = Time.now + credentials['expires_in'].to_i
  end

  def refresh_access_token!
    credentials = send_oauth2_request({
      'refresh_token' => refresh_token,
      'grant_type' => 'refresh_token'
    })

    set_access_token_and_expiry(credentials)
    self.expires_at = Time.now + credentials['expires_in'].to_i
    save
    return self.access_token
  end

  def send_oauth2_request(params)
    conn = Faraday.new(:url => 'https://accounts.google.com',:ssl => {:verify => false}) do |faraday|
     faraday.request  :url_encoded
     faraday.response :logger
     faraday.adapter  Faraday.default_adapter
    end

    result = conn.post '/o/oauth2/token', {
      'client_id' => Settings.google_client_id,
      'client_secret' => Settings.google_client_secret
    }.merge(params)

    JSON.parse(result.body)
  end

end
