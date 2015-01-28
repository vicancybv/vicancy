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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reseller do
    name 'Vicancy'
    language 'es'
    # slug 'vicancy'
    # token 'some_random_token'
    # secret 'some_random_secret'
  end

  factory :reseller2, class: 'Reseller' do
    name 'Monster Jobs'
    # slug 'monster_jobs'
    # token 'monster_jobs_token'
    # secret 'some_random_secret'
  end
end
