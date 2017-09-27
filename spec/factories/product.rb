FactoryGirl.define do
  factory :product do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    image_url { Faker::Avatar.image }
    price_cents { Faker::Number.between(100, 10000) }
  end
end
