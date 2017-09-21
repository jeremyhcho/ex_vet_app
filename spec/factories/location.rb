FactoryGirl.define do
  factory :location do
    name { Faker::Company.name }
    country { Faker::Address.country }
    state { Faker::Address.state }
    city { Faker::Address.city }
    address { Faker::Address.street_address }
    zip { Faker::Address.zip_code }
  end
end
