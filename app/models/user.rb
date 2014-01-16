class User < ActiveRecord::Base
  has_many :videos, :dependent => :destroy
  has_many :video_requests, :dependent => :destroy
  accepts_nested_attributes_for :videos, :allow_destroy => true
  attr_accessible :name, :slug, :language
  after_validation :generate_slug, on: :create

  def generate_slug
  	return unless slug.blank?
    record = true
    while record
      random = Array.new(8){%w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample}.join
      record = User.find_by_slug(random)
    end          
    self.slug = random
  end
end
