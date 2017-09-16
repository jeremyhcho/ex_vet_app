FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password_digest { Digest::SHA256.hexdigest(SecureRandom.base64) }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
