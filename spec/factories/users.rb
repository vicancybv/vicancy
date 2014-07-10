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
