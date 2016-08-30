FactoryGirl.define do
  factory :proverb do
    body {Faker::Lorem.paragraphs}
    language "en"
    user

    trait :invalid do
      body " "
      language "en"
    end
  end
end
