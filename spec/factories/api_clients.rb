FactoryBot.define do
  factory :api_client do
    name { Faker::Name.name }
    api_token { Faker::Internet.password }
  end
end
