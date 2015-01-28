# == Schema Information
#
# Table name: resellers
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)      indexed
#  language    :string(255)
#  token       :string(255)      indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  secret      :string(255)
#  public_slug :string(255)      indexed
#

class Reseller < ActiveRecord::Base
  has_many :clients

  attr_accessible :language, :name, :slug, :public_slug, :token, :secret

  after_validation :generate_slug, on: :create
  after_validation :generate_public_slug, on: :create
  after_validation :generate_token, on: :create
  after_validation :generate_secret, on: :create

  def intercom_id
    "reseller-#{self.slug}"
  end

  def generate_slug
    return unless slug.blank?
    record = true
    while record
      random = Array.new(8){%w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample}.join
      record = Client.find_by_slug(random) || Reseller.find_by_slug(random)
    end
    self.slug = random
  end

  def generate_public_slug
    return unless public_slug.blank?
    record = true
    while record
      random = Array.new(16){%w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample}.join
      record = Reseller.find_by_public_slug(random)
    end
    self.public_slug = random
  end

  def generate_token
    return if token.present?
    record = true
    while record
      random = SecureRandom.urlsafe_base64(16)
      record = Reseller.find_by_token(random)
    end
    self.token = random
  end

  def generate_secret
    return if secret.present?
    self.secret = SecureRandom.urlsafe_base64(32)
  end
end
