FactoryGirl.define do
  factory :session do
    token { Digest::SHA256.hexdigest(SecureRandom.base64) }
  end
end
