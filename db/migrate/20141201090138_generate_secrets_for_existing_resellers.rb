class GenerateSecretsForExistingResellers < ActiveRecord::Migration
  class Reseller < ActiveRecord::Base
    attr_accessible :secret
  end

  def change
    Reseller.where(secret: nil).each do |reseller|
      reseller.update_column(:secret, SecureRandom.urlsafe_base64(32))
    end
  end

end
