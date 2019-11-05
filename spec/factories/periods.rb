FactoryBot.define do
  factory :period do
    user
    started_at { Time.current }
    ended_at { 5.hours.from_now }
  end
end
