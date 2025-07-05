FactoryBot.define do
  factory :url do
    original_url { Faker::Internet.url }
    short_code { Faker::Alphanumeric.alpha(number: 6) }
  end
end
