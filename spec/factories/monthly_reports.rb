FactoryBot.define do
  factory :monthly_report do
    user
    month { Time.current.month }
    year { Time.current.year }
  end
end
