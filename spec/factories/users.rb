FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password '!Passw0rd'
    confirmation_token { '0123456789' }
    confirmation_sent_at { Time.now.utc }
    confirmed_at { Time.now.utc }
  end
end
