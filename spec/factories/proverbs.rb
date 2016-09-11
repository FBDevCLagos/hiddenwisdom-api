FactoryGirl.define do
  factory :proverb do
    body { Faker::Lorem.paragraphs }
    language "en"
    all_tags ["wisdom", "life"]
    user

    trait :invalid do
      body " "
      language "en"
    end
  end
end
