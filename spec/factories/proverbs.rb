FactoryGirl.define do
  factory :proverb do
    body {Faker::Lorem.paragraphs}
    language "en"

    factory :bad_proverb do
      body " "
      language "en"
    end
  end
end
