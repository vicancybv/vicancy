class TransformUsersIntoResellersMigration
  attr_accessor :reseller_names, :test_names

  def initialize
    @test_names = []
    @reseller_names = []
  end

  class User < ActiveRecord::Base
    has_many :videos
    has_many :video_requests
    attr_accessible :name, :slug, :language, :token
  end

  class Reseller < ActiveRecord::Base
    has_many :clients
    attr_accessible :language, :name, :slug, :token

    after_validation :generate_slug, on: :create
    after_validation :generate_token, on: :create

    private

    def generate_slug
      return unless slug.blank?
      record = true
      while record
        random = Array.new(8) { %w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample }.join
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

  class Video < ActiveRecord::Base
    belongs_to :user
    belongs_to :client

    attr_accessible :company, :job_ad_url, :job_title, :language, :summary, :title, :user_id, :client_id
  end

  class VideoRequest < ActiveRecord::Base
    belongs_to :user
    belongs_to :client
  end


  class Client < ActiveRecord::Base
    has_many :videos, :dependent => :destroy
    has_many :video_requests, :dependent => :destroy
    accepts_nested_attributes_for :videos, :allow_destroy => true

    attr_accessible :email, :external_id, :name, :language, :slug, :token, :user_id
    belongs_to :user

    after_validation :generate_slug, on: :create
    after_validation :generate_token, on: :create
    after_validation :generate_temp_external_id, on: :create

    private

    def generate_temp_external_id
      return unless external_id.blank?
      record = true
      while record
        random = Array.new(4) { %w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample }.join
        random = '?unknown? '+random
        record = Client.find_by_external_id(random)
      end
      self.external_id = random
    end


    def generate_slug
      return unless slug.blank?
      record = true
      while record
        random = Array.new(8) { %w(a b c d e f g h j k m n p q r s t u v w x y z 2 3 4 5 6 7 8 9).sample }.join
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

  def user_is_reseller(user)
    language = user.language.present? ? user.language : 'en'
    reseller = Reseller.create!(name: user.name, slug: user.slug, language: language)
    videos = user.videos.to_a
    companies = videos.map(&:company).uniq
    companies.each do |company|
      client_videos = videos.select { |v| v.company == company }
      client = reseller.clients.create!(name: company, language: client_videos.first.language)
      client_videos.each do |video|
        video.update_attribute(:client_id, client.id)
      end
    end
    client = (reseller.clients.to_a.sort_by { |c| c.name }).first
    user.video_requests.update_all(client_id: client.id)
    reseller
  end

  def user_is_test_account(user)
    transform_user_into_client(user, vicancy_test_acc)
  end

  def user_is_vicancy_client(user)
    transform_user_into_client(user, vicancy_reseller)
  end

  def transform_user_into_client(user, reseller)
    language = user.language.present? ? user.language : 'en'
    client = reseller.clients.create!(name: user.name, language: user.language, slug: user.slug)
    user.videos.update_all(client_id: client.id)
    user.video_requests.update_all(client_id: client.id)
    client
  end

  def vicancy_reseller
    return @reseller if @reseller
    @reseller = Reseller.find_by_name('Vicancy')
    @reseller ||= Reseller.create!(name: 'Vicancy', language: 'en')
    @reseller
  end

  def vicancy_test_acc
    return @test_acc if @test_acc
    @test_acc = Reseller.find_by_name('Vicancy (test)')
    @test_acc ||= Reseller.create!(name: 'Vicancy (test)', language: 'en')
    @test_acc
  end

  def run
    users = User.all.to_a
    users.each do |user|
      if @test_names.include? user.name
        user_is_test_account(user)
      elsif @reseller_names.include? user.name
        user_is_reseller(user)
      else
        user_is_vicancy_client(user)
      end
    end
  end

end