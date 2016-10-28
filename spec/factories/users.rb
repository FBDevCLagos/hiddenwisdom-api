FactoryGirl.define do
  factory :user do
    email { Faker::Internet.free_email }
    phone_number { Faker::PhoneNumber.phone_number }
    kit_id { Faker::Number.digit }
  end
end
