FactoryGirl.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    company_name { Faker::Company.name }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
