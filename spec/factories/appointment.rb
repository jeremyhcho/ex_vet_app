FactoryGirl.define do
  factory :appointment do
    from { Faker::Time.between(5.hours.ago, 1.hour.ago) }
    to { Faker::Time.between(1.hour.ago, DateTime.now) }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
