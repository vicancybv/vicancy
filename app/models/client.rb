# == Schema Information
#
# Table name: clients
#
#  id          :integer          not null, primary key
#  user_id     :integer          indexed, indexed => [external_id]
#  external_id :string(255)      indexed => [user_id]
#  name        :string(255)
#  email       :string(255)
#  language    :string(255)
#  slug        :string(255)      indexed
#  token       :string(255)      indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Client < ActiveRecord::Base
  attr_accessible :email, :external_id, :name, :language, :slug, :token, :user_id
  belongs_to :user

  after_validation :generate_slug, on: :create
  after_validation :generate_token, on: :create

  private

  def generate_slug
    return unless slug.blank?
    record = true
    while record
      random = Array.new(8){%w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample}.join
      record = Client.find_by_slug(random)
    end
    self.slug = random
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
