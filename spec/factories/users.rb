# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  language   :string(255)
#  token      :string(255)      indexed
#

FactoryGirl.define do

  factory :user do
    name 'Vicancy'
    slug 'vicancy'
    token 'some_random_token'
  end

  factory :user2, class: 'User' do
    name 'Monster Jobs'
    slug 'monster_jobs'
    token 'monster_jobs_token'
  end

end
