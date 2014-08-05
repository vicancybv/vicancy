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

FactoryGirl.define do

  factory :client do
    name 'McKinsey'
    email 'mckinsey@example.com'
    language 'en'
    external_id '639141'
  end

end
