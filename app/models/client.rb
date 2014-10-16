# == Schema Information
#
# Table name: clients
#
#  id                 :integer          not null, primary key
#  user_id            :integer          indexed
#  external_id        :string(255)      indexed => [reseller_id]
#  name               :string(255)
#  email              :string(255)
#  language           :string(255)
#  slug               :string(255)      indexed
#  token              :string(255)      indexed
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  reseller_id        :integer          indexed, indexed => [external_id]
#  sign_in_count      :integer          default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#

class Client < ActiveRecord::Base
  has_many :videos, :dependent => :destroy
  has_many :video_requests, :dependent => :destroy
  accepts_nested_attributes_for :videos, :allow_destroy => true

  attr_accessible :email, :external_id, :name, :language, :slug, :token, :user_id, :reseller_id,
                  :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip
  belongs_to :user
  belongs_to :reseller

  after_validation :generate_slug, on: :create
  after_validation :generate_token, on: :create
  after_validation :generate_external_id, on: :create

  def intercom_id
    "client-#{self.slug}"
  end

  def intercom_created_at
    self.created_at.to_i
  end

  def same_session?(new_sign_in_at, new_sign_in_ip)
    if current_sign_in_at.blank?
      return false
    elsif current_sign_in_ip.blank?
      return false
    elsif current_sign_in_ip != new_sign_in_ip
      return false
    else
      if (new_sign_in_at.to_i - current_sign_in_at.to_i) > Settings.widget_session_length_to_count_as_single_sign_in * 60
        return false
      else
        return true
      end
    end
  end

  def get_language
    if language.present?
      language
    elsif reseller.language.present?
      reseller.language
    else
      'en'
    end
  end

  private

  def generate_slug
    return unless slug.blank?
    record = true
    while record
      random = Array.new(8) { %w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample }.join
      record = Client.find_by_slug(random) || Reseller.find_by_slug(random)
    end
    self.slug = random
  end

  def generate_external_id
    return unless external_id.blank?
    record = true
    while record
      random = Array.new(8) { %w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample }.join
      random = '?autogen? ' + random
      record = Client.where(reseller_id: self.reseller_id, external_id: random).first
    end
    self.external_id = random
  end

  def generate_token
    return unless token.blank?
    record = true
    while record
      random = SecureRandom.urlsafe_base64(16)
      record = Client.find_by_token(random)
    end
    self.token = random
  end

end
