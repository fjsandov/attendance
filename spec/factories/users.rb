password = Faker::Internet.password

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    name { Faker::Name.name }

    factory :admin do
      admin { true }
    end

    factory :inactive_user do
      active { false }
    end
  end
end
