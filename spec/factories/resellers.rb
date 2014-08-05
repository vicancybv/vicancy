# == Schema Information
#
# Table name: resellers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  language   :string(255)
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reseller do
    name "MyString"
    slug "MyString"
    language "MyString"
    token "MyString"
  end
end
