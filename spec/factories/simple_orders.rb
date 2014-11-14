# == Schema Information
#
# Table name: simple_orders
#
#  id         :integer          not null, primary key
#  params     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  referer    :string(255)
#  email      :string(255)
#  name       :string(255)
#  url        :string(255)
#  product    :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :simple_order do
    params "MyText"
  end
end
