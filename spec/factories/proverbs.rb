FactoryGirl.define do
  factory :proverb do
    body { Faker::Lorem.paragraphs }
    locale 'en'
    user

    trait :invalid do
      body " "
      locale 'en'
    end
  end
end
