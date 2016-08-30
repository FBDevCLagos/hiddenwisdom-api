FactoryGirl.define do
  factory :user do
    email { Faker::Internet.free_email }
    username { Faker::Name.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    fb_id Faker::Number.digit
  end
end
