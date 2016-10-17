FactoryGirl.define do
  factory :proverb do
    body { Faker::Lorem.paragraph }
    user

    trait :invalid do
      body " "
    end
  end
end
