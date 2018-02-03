FactoryBot.define do
  factory :user_role do
    user { User.create!(email: 'someuser@gmail.com', password: 'password') }
    role { Role.create!(name: 'somerole') }
  end
end
