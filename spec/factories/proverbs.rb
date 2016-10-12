FactoryGirl.define do
  factory :proverb do
    body { Faker::Lorem.paragraphs }
    user

    trait :invalid do
      body " "
    end
  end
end
