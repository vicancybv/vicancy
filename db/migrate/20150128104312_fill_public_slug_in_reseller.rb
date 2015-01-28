class FillPublicSlugInReseller < ActiveRecord::Migration
  class Reseller < ActiveRecord::Base
    attr_accessible :public_slug
  end

  def change
    Reseller.where(public_slug: nil).each do |reseller|
      record = true
      while record
        random = Array.new(16){%w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample}.join
        record = Reseller.find_by_public_slug(random)
      end
      reseller.update_column(:public_slug, random)
    end
  end
end
