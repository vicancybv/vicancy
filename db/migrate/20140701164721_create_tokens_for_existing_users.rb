class CreateTokensForExistingUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
    attr_accessible :token
  end

  def change
    User.where(token: nil).each do |user|
      user.update_column(:token, SecureRandom.urlsafe_base64(16))
    end
  end

end
