FactoryBot.define do
  factory :url do
    original_url { Faker::Internet.url }
    short_code { Faker::Alphanumeric.alpha(number: 6) }

    trait :with_base62_short_code do
      after(:create) do |url|
        code = Base62Encoder.encode(url.id)
        url.update!(short_code: code)
      end
    end

    trait :with_hashids_short_code do
      after(:create) do |url|
        code = HashidsEncoder.encode(url.id)
        url.update!(short_code: code)
      end
    end
  end
end
