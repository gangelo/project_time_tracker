FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    user_name { FFaker.bothify('?????_????_?????') }
    password 'password'
    password_confirmation 'password'
    confirmation_token { '0123456789' }
    confirmation_sent_at { Time.now.utc }
    confirmed_at { Time.now.utc }

    factory :user_with_user_role do
      after(:create) do |user, evaluator|
        user.roles << Role.user
      end
    end

    factory :user_with_admin_role do
      after(:create) do |user, evaluator|
        user.roles << Role.admin
      end
    end
  end
end
